//
//  AppStateManagement.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 10/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

protocol AppStateManagement {
    var state: AppState { get }
    var onVpnStateChanged: ((VpnState) -> Void)? { get set }
    var displayState: AppDisplayState { get }
    
    func isOnDemandEnabled(handler: @escaping (Bool) -> Void)
    
    func cancelConnectionAttempt()
    func cancelConnectionAttempt(completion: @escaping () -> Void)
    
    func prepareToConnect()
    func disconnect()
    func disconnect(completion: @escaping () -> Void)
    
    func refreshState()
    
    func checkNetworkConditionsAndCredentialsAndConnect(withConfiguration configuration: ConnectionConfiguration)
}

class SysVpnAppStateManagement: AppStateManagement {
    private var attemptingConnection = false
    private var _state: AppState = .disconnected

    public private(set) var state: AppState {
        get {
            dispatchAssert(condition: .onQueue(.main))
            return _state
        }
        set {
            dispatchAssert(condition: .onQueue(.main))
            _state = newValue
            computeDisplayState(with: vpnManager.isLocalAgentConnected)
        }
    }

    var sessionStartTime: Double? {
        return vpnManager.sessionStartTime
    }
    
    private var vpnManager: SysVPNManagerProtocol
    var onVpnStateChanged: ((VpnState) -> Void)?
    var displayState: AppDisplayState = .disconnected {
        didSet {
            GlobalAppStates.shared.displayState = displayState
            switch displayState {
            case .connected:
                startBitrateMonitor()
            case .disconnected:
                stopBitrateMonitor()
            default:
                break
            }
        }
    }

    private var lastAttemptedConfiguration: ConnectionConfiguration? {
        set {
            newValue.saveUserDefault(keyUserDefault: "appStateLastConnectionConiguration")
        }
        get {
            return ConnectionConfiguration.readUserDefault(keyUserDefault: "appStateLastConnectionConiguration")
        }
    }

    private var timeoutTimer: BackgroundTimer?
    private var timerFactory = TimerFactoryImplementation()
    var statistics: NetworkStatistics?
    
    private var vpnState: VpnState = .invalid {
        didSet {
            onVpnStateChanged?(vpnState)
        }
    }

    private var stuckDisconnecting = false {
        didSet {
            if stuckDisconnecting == false {
                reconnectingAfterStuckDisconnecting = false
            }
        }
    }

    private var reconnectingAfterStuckDisconnecting = false
    
    init(vpnManager: SysVPNManagerProtocol) {
        self.vpnManager = vpnManager
        handleVpnStateChange(vpnManager.state)
        startObserving()
    }
    
    func startBitrateMonitor() {
        if statistics != nil {
            return
        }
        statistics = NetworkStatistics(with: 1, and: { bitrate in
            NetworkAppStates.shared.bitRate = bitrate
        })
    }
    
    func stopBitrateMonitor() {
        statistics?.stopGathering()
        statistics = nil
    }
    
    func isOnDemandEnabled(handler: @escaping (Bool) -> Void) {
        vpnManager.isOnDemandEnabled(handler: handler)
    }
    
    func cancelConnectionAttempt() {
        cancelConnectionAttempt {}
    }
    
    func cancelConnectionAttempt(completion: @escaping () -> Void) {
        state = .aborted(userInitiated: true)
        attemptingConnection = false
        cancelTimeout()
        
        notifyObservers()
        disconnect(completion: completion)
    }
    
    func prepareToConnect() {
        if !PropertiesManager.shared.hasConnected {
            switch vpnState {
            case .disconnecting:
                vpnStuck()
                return
            default:
                print("first time connect")
            }
        }
        
        // check cert / keychain
        
        if case VpnState.disconnecting = vpnState {
            stuckDisconnecting = true
        }
        state = .preparingConnection
        attemptingConnection = true
        beginTimeoutCountdown()
        notifyObservers()
    }
    
    private func vpnStuck() {
        vpnManager.removeConfigurations(completionHandler: { [weak self] error in
            guard let self = self else {
                return
            }

            guard error == nil, self.reconnectingAfterStuckDisconnecting == false, let lastConfig = self.lastAttemptedConfiguration else {
                // connect failed
                self.connectionFailed()
                return
            }
            
            self.reconnectingAfterStuckDisconnecting = true
            self.checkNetworkConditionsAndCredentialsAndConnect(withConfiguration: lastConfig)
        })
    }
    
    private func connectionFailed() {
        state = .error(NSError(domain: "", code: 0))
        notifyObservers()
    }
    
    private func beginTimeoutCountdown() {
        cancelTimeout()

        timeoutTimer = timerFactory.scheduledTimer(runAt: Date().addingTimeInterval(30),
                                                   leeway: .seconds(5),
                                                   queue: .main) { [weak self] in
            self?.timeout()
        }
    }
    
    @objc private func timeout() {
        state = .aborted(userInitiated: false)
        attemptingConnection = false
        cancelTimeout()
        stopAttemptingConnection()
        notifyObservers()
    }
    
    private func stopAttemptingConnection() { 
        cancelTimeout()
        handleVpnError(vpnState)
        disconnect()
    }
    
    private func cancelTimeout() {
        timeoutTimer?.invalidate()
    }
    
    public func disconnect() {
        disconnect {}
    }
    
    public func disconnect(completion: @escaping () -> Void) {
        PropertiesManager.shared.intentionallyDisconnected = true
        vpnManager.disconnect(completion: completion)
    }
    
    func refreshState() {
        vpnManager.refreshState()
    }
  
    func checkNetworkConditionsAndCredentialsAndConnect(withConfiguration configuration: ConnectionConfiguration) {
        if case AppState.aborted = state { return }
        
        // To-do: check reachability
        // ...
        
        lastAttemptedConfiguration = configuration
        attemptingConnection = true
        
        // To-do: check config outdate
        // ..
        
        configureVPNManagerAndConnect(configuration)
    }
    
    func configureVPNManagerAndConnect(_ configuration: ConnectionConfiguration) {
        let vpnManagerConfiguration = SysVPNConfiguration(username: "", password: "", adapterTitle: "sysvpn", connection: configuration.connectionDetermine.connectionString, vpnProtocol: configuration.connectionDetermine.vpnProtocol, passwordReference: Data())
        vpnManager.disconnectAnyExistingConnectionAndPrepareToConnect(with: vpnManagerConfiguration) {
            /* DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                 self.vpnManager.setOnDemand(false)
             }*/
        }
    }
    
    private func notifyObservers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            NotificationCenter.default.post(name: AppStateManagerNotification.stateChange, object: self.state)
        }
    }
    
    private func handleVpnError(_ vpnState: VpnState) {
        if case VpnState.disconnecting = vpnState, stuckDisconnecting {
            vpnStuck()
            return
        }
        
        attemptingConnection = false
        connectionFailed()
    }
    
    private func handleVpnStateChange(_ vpnState: VpnState) {
        if case VpnState.disconnecting = vpnState {} else {
            stuckDisconnecting = false
        }
        
        switch vpnState {
        case .invalid:
            return // NEVPNManager hasn't initialised yet
        case .disconnected:
            if attemptingConnection {
                state = .preparingConnection
                return
            } else {
                updateUIDisconnectedInfo()
                state = .disconnected
            }
        case let .connecting(descriptor):
            state = .connecting(descriptor)
        case let .connected(descriptor):
            PropertiesManager.shared.intentionallyDisconnected = false
            
            /* serviceChecker?.stop()
             if let alertService = alertService {
                 serviceChecker = ServiceChecker(networking: networking, alertService: alertService, doh: doh)
             } */
            updateUIConnectedInfo()
            attemptingConnection = false
            state = .connected(descriptor)
           
            cancelTimeout()
        case .reasserting:
            return // usually this step is quick
        case let .disconnecting(descriptor):
            if attemptingConnection { // needs to disconnect before attempting to connect
                if case AppState.connecting = state {
                    stopAttemptingConnection()
                } else {
                    state = .preparingConnection
                }
            } else {
                state = .disconnecting(descriptor)
            }
        case let .error(error):
            state = .error(error)
        }
        /*
         if !state.isConnected {
             serviceChecker?.stop()
             serviceChecker = nil
         }*/
        
        notifyObservers()
    }
    
    private func updateUIConnectedInfo() {
        guard let lastConfig = lastAttemptedConfiguration else {
            return
        }
        MapAppStates.shared.serverInfo = lastConfig.serverInfo
        MapAppStates.shared.connectedNode = AppDataManager.shared.getNodeByServerInfo(server: lastConfig.serverInfo)
    }
    
    private func updateUIDisconnectedInfo() {
        MapAppStates.shared.connectedNode = nil
    }

    @objc private func vpnStateChanged() {
        let newState = vpnManager.state
        switch newState {
        case .error:
            if case VpnState.invalid = vpnState {
                vpnState = newState
                return
            } else if attemptingConnection {
                stopAttemptingConnection()
            }
        default:
            break
        }
        
        vpnState = newState
        handleVpnStateChange(newState)
    }
    
    private func startObserving() {
        vpnManager.stateChanged = { [weak self] in
            executeOnUIThread {
                self?.vpnStateChanged()
            }
        }
        vpnManager.localAgentStateChanged = { [weak self] localAgentConnectedState in
            executeOnUIThread {
                self?.computeDisplayState(with: localAgentConnectedState)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(killSwitchChanged), name: PropertiesManager.killSwitchNotification, object: nil)
    }
    
    @objc private func killSwitchChanged() {
        if state.isConnected {
            PropertiesManager.shared.intentionallyDisconnected = true
            vpnManager.setOnDemand(PropertiesManager.shared.hasConnected)
        }
    }
    
    private func computeDisplayState(with localAgentConnectedState: Bool?) {
        guard let isLocalAgentConnected = localAgentConnectedState else {
            displayState = state.asDisplayState()
            return
        }
 
        if !isLocalAgentConnected, case AppState.connected = state, !PropertiesManager.shared.intentionallyDisconnected {
            // log.debug("Showing state as Loading connection info because local agent not connected yet", category: .connectionConnect)
            displayState = .loadingConnectionInfo
            return
        }

        displayState = state.asDisplayState()
    }
}

public func dispatchAssert(condition: DispatchPredicate) {
    #if DEBUG
        dispatchPrecondition(condition: condition)
    #endif
}
