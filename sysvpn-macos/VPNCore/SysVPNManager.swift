//
//  SysVPNManager.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import NetworkExtension

class SysVPNManager : SysVPNManagerProtocol {
    
    private var quickReconnection = false
    private let localAgentIsConnectedQueue = DispatchQueue(label: "gn.local-agent.is-connected")
    internal let connectionQueue = DispatchQueue(label: "vpn.connection", qos: .utility)
    internal var disconnectOnCertRefreshError = true
    private var connectAllowed = true
    private var disconnectCompletion: (() -> Void)?
    var stateChanged: (() -> Void)?
    private var delayedDisconnectRequest: (() -> Void)?

    private var _isLocalAgentConnectedNoSync: Bool?
    private let appGroup: String
    private(set) var state: VpnState = .invalid
    var readyGroup: DispatchGroup? = DispatchGroup()
    
    private let vpnCredentialsConfiguratorFactory: SysVPNCredentialsConfiguratorFactory
    private let openVpnProtocolFactory: VpnProtocolFactory
    private let wireguardProtocolFactory: VpnProtocolFactory
    
    var currentVpnProtocol: VpnProtocol? {
        didSet {
            if oldValue == nil, let delayedRequest = delayedDisconnectRequest {
                delayedRequest()
                delayedDisconnectRequest = nil
            }
            print("[VPN] update currentVpnProtocol \(currentVpnProtocol)")
        }
    }
    
    var localAgentStateChanged: ((Bool?) -> Void)?
    
    var isLocalAgentConnected: Bool? {
        get {
            return localAgentIsConnectedQueue.sync {
                _isLocalAgentConnectedNoSync
            }
        }
        set {
            var oldValue: Bool?
            localAgentIsConnectedQueue.sync {
                oldValue = _isLocalAgentConnectedNoSync
                _isLocalAgentConnectedNoSync = newValue
            }

            guard isLocalAgentConnected != oldValue else {
                return
            }
            localAgentStateChanged?(isLocalAgentConnected)
        }
    }
    
    private let vpnStateConfiguration: SysVPNStateConfiguration
    
    private var currentVpnProtocolFactory: VpnProtocolFactory? {
        guard let currentVpnProtocol = currentVpnProtocol else {
            print("[VPN] error: Current config protocol null")
            return nil
        }
        
        switch currentVpnProtocol { 
            case .openVpn:
                return openVpnProtocolFactory
            case .wireGuard:
                return wireguardProtocolFactory
        }
    }

    init(
        appGroup: String,
        vpnCredentialsConfiguratorFactory : SysVPNCredentialsConfiguratorFactory , openVpnProtocolFactory: VpnProtocolFactory, wireguardProtocolFactory: VpnProtocolFactory, vpnStateConfiguration : SysVPNStateConfiguration) {
        self.vpnCredentialsConfiguratorFactory = vpnCredentialsConfiguratorFactory
        self.openVpnProtocolFactory = openVpnProtocolFactory
        self.wireguardProtocolFactory = wireguardProtocolFactory
        self.vpnStateConfiguration = vpnStateConfiguration
        self.appGroup = appGroup
        self.prepareManagers(forSetup: true)
    }
     
    public func isOnDemandEnabled(handler: @escaping (Bool) -> Void) {
        guard let currentVpnProtocolFactory = currentVpnProtocolFactory else {
            handler(false)
            return
        }
        
        currentVpnProtocolFactory.vpnProviderManager(for: .status) { vpnManager, _ in
            guard let vpnManager = vpnManager else {
                handler(false)
                return
            }
            
            handler(vpnManager.isOnDemandEnabled)
        }
    }
    
    public func setOnDemand(_ enabled: Bool) {
        connectionQueue.async { [weak self] in
            self?.setOnDemand(enabled) { _ in
            }
        }
    }
    
    public func disconnectAnyExistingConnectionAndPrepareToConnect(with configuration: SysVpnManagerConfiguration, completion: @escaping () -> Void) {
        let pause = state != .disconnected ? 0.2 : 0
        print("[VPN] About to start connection process")
        
        let connectWrapper = { [weak self] in
            print("[VPN] debug \(configuration.vpnProtocol)")
            self?.currentVpnProtocol = configuration.vpnProtocol
            self?.connectAllowed = true
            self?.connectionQueue.asyncAfter(deadline: .now() + pause) { [weak self] in
                self?.prepareConnection(forConfiguration: configuration, completion: completion)
            }
        }
        disconnect {
            connectWrapper()
        }
        
    }
    
    
    
    func disconnect(completion: @escaping () -> Void) {
        executeDisconnectionRequestWhenReady { [weak self] in
            self?.connectAllowed = false
            self?.connectionQueue.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.startDisconnect(completion: completion)
            }
        }
    }
    
    
    public func connectedDate(completion: @escaping (Date?) -> Void) {
        guard let currentVpnProtocolFactory = currentVpnProtocolFactory else {
            completion(nil)
            return
        }
        
        currentVpnProtocolFactory.vpnProviderManager(for: .status) { [weak self] vpnManager, error in
            guard let self = self else {
                completion(nil)
                return
            }

            if error != nil {
                completion(nil)
                return
            }

            guard let vpnManager = vpnManager else {
                completion(nil)
                return
            }
            
            // Returns a date if currently connected
            if case VpnState.connected(_) = self.state {
                completion(vpnManager.vpnConnection.connectedDate)
            } else {
                completion(nil)
            }
        }
    }
    
    public func refreshState() {
        setState()
    }
    
    public func refreshManagers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        
        prepareManagers()
    }
    
    private func startDisconnect(completion: @escaping (() -> Void)) {
        print("[VPN] connectionDisconnect: Closing VPN tunnel")

        //localAgent?.disconnect()
        disconnectCompletion = completion
        
        setOnDemand(false, completion: { vpnManager in
            self.stopTunnelOrRunCompletion(vpnManager: vpnManager)
        }) {
            self.disconnectCompletion?()
        }
    }
    
    func removeConfigurations(completionHandler: ((Error?) -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        var error: Error?
        var successful = false
        for factory in [openVpnProtocolFactory, wireguardProtocolFactory] {
            dispatchGroup.enter()
            removeConfiguration(factory) { e in
                if e != nil {
                    error = e
                } else {
                    successful = true
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler?(successful ? nil : error)
        }
    }
    
    func whenReady(queue: DispatchQueue, completion: @escaping () -> Void) {
        self.readyGroup?.notify(queue: queue) {
            completion()
            self.readyGroup = nil
        }
    }
    
  
    
    public func appBackgroundStateDidChange(isBackground: Bool) {
        connectionQueue.sync { [weak self] in
            self?.disconnectOnCertRefreshError = !isBackground
        }
    }
    
    @objc private func vpnStatusChanged() {
        setState()
    }
    
    private func stopTunnelOrRunCompletion(vpnManager: NEVPNManagerWrapper) {
        switch self.state {
        case .disconnected, .error, .invalid:
            disconnectCompletion?()
            disconnectCompletion = nil
        default:
            vpnManager.vpnConnection.stopVPNTunnel()
        }
    }
    
    private func prepareManagers(forSetup: Bool = false) {
        vpnStateConfiguration.determineActiveVpnProtocol() { [weak self] vpnProtocol in
            guard let self = self else {
                return
            }
            
            self.currentVpnProtocol = vpnProtocol
            self.setState()

            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.vpnStatusChanged),
                                                   name: NSNotification.Name.NEVPNStatusDidChange, object: nil)

            if forSetup {
                self.readyGroup?.leave()
            }
        }
    }
    
    private func removeConfiguration(_ protocolFactory: VpnProtocolFactory, completionHandler: ((Error?) -> Void)?) {
        protocolFactory.vpnProviderManager(for: .configuration) { vpnManager, error in
            if let error = error {
                //log.error("\(error)", category: .ui)
                completionHandler?(SysVPNError.removeVpnProfileFailed)
                return
            }
            guard let vpnManager = vpnManager else {
                completionHandler?(SysVPNError.removeVpnProfileFailed)
                return
            }
            
            vpnManager.protocolConfiguration = nil
            vpnManager.removeFromPreferences(completionHandler: completionHandler)
        }
    }
    
    private func startConnection(completion: @escaping () -> Void) {
        guard connectAllowed, let currentVpnProtocolFactory = currentVpnProtocolFactory else {
            return
        }
        
        print("[VPN] connectionConnect: Loading connection configuration")
        currentVpnProtocolFactory.vpnProviderManager(for: .configuration) { [weak self] vpnManager, error in
            guard let self = self else {
                return
            }

            if let error = error {
                self.setState(withError: error)
                return
            }
            guard let vpnManager = vpnManager else { return }
            guard self.connectAllowed else { return }
            do {
                print("[VPN] connectionConnect: Starting VPN tunnel")
                try vpnManager.vpnConnection.startVPNTunnel()
                completion()
            } catch {
                self.setState(withError: error)
            }
        }
    }
    
    
    private func configureConnection(forProtocol configuration: NEVPNProtocol,
                                     vpnManager: NEVPNManagerWrapper,
                                     completion: @escaping () -> Void) {
        guard connectAllowed else {
            return
        }
        
        print("[VPN] connectionConnect: Configuring connection")
        
       
        // test kill switch
        
        PropertiesManager.shared.hasConnected = true
        PropertiesManager.shared.killSwitch = true
        PropertiesManager.shared.excludeLocalNetworks = true
        
        
        // MARK: - KillSwitch configuration
        #if os(OSX)
            configuration.includeAllNetworks = PropertiesManager.shared.killSwitch
            configuration.excludeLocalNetworks =  PropertiesManager.shared.excludeLocalNetworks
        #elseif os(iOS)
        if #available(iOS 14, *) {
            configuration.includeAllNetworks = PropertiesManager.shared.killSwitch
        }
        if #available(iOS 14.2, *) {
            configuration.excludeLocalNetworks =  PropertiesManager.shared.excludeLocalNetworks
        }
        #endif
       
        vpnManager.protocolConfiguration = configuration
        vpnManager.onDemandRules = [NEOnDemandRuleConnect()]
        vpnManager.isOnDemandEnabled =  PropertiesManager.shared.hasConnected
        vpnManager.isEnabled = true
        
        vpnManager.saveToPreferences { [weak self] saveError in
            guard let self = self else {
                return
            }

            if let saveError = saveError {
                self.setState(withError: saveError)
                return
            }
            completion()
        }
                
    }
    
    
    private func prepareConnection(forConfiguration configuration: SysVpnManagerConfiguration,
                                   completion: @escaping () -> Void) {
        if state.volatileConnection {
            setState()
            return
        }

       
        disconnectLocalAgent()
        
        guard let currentVpnProtocolFactory = currentVpnProtocolFactory else {
            return
        }
        
        print("[VPN] connectionConnect: Creating connection configuration")
        currentVpnProtocolFactory.vpnProviderManager(for: .configuration) { [weak self] vpnManager, error in
            guard let self = self else {
                return
            }

            if let error = error {
                self.setState(withError: error)
                return
            }
            
           
            guard let vpnManager = vpnManager else { return }
            
            do {
                let protocolConfiguration = try currentVpnProtocolFactory.create(configuration)
                let credentialsConfigurator = self.vpnCredentialsConfiguratorFactory.getCredentialsConfigurator(for: configuration.vpnProtocol)
                credentialsConfigurator.prepareCredentials(for: protocolConfiguration, configuration: configuration) { protocolConfigurationWithCreds in
                    self.configureConnection(forProtocol: protocolConfigurationWithCreds, vpnManager: vpnManager) {
                        self.startConnection(completion: completion)
                    }
                }
                
            } catch {
               // log.error("\(error)", category: .ui)
            }
        }
    }
    
    private func setOnDemand(_ enabled: Bool, completion: @escaping (NEVPNManagerWrapper) -> Void, error: (()->Void)? = nil) {
        guard let currentVpnProtocolFactory = currentVpnProtocolFactory else {
            error?()
            return
        }
        
        currentVpnProtocolFactory.vpnProviderManager(for: .configuration) { [weak self] vpnManager, error in
            guard let self = self else {
                return
            }

            if let error = error {
                print("[VPN] connection error: 1")
                self.setState(withError: error)
                return
            }

            guard let vpnManager = vpnManager else {
                print("[VPN] connection error: vpnManager null")
                self.setState(withError: SysVPNError.vpnManagerUnavailable)
                return
            }
            
            vpnManager.onDemandRules = [NEOnDemandRuleConnect()]
            vpnManager.isOnDemandEnabled = enabled
            print("[VPN] connectionConnect: On Demand set: \(enabled ? "On" : "Off") for \(currentVpnProtocolFactory.self)")
            
            vpnManager.saveToPreferences { [weak self] error in
                guard let self = self else {
                    return
                }

                if let error = error {
                    print("[VPN] connection: error")
                    self.setState(withError: error)
                    return
                }
                print("[VPN] connection: saveToPreferences")
                completion(vpnManager)
            }
        }
    }
    
    private func setState(withError error: Error? = nil) {
        if let error = error {
            print("[VPN] connection: VPN error: \(error)")
            state = .error(error)
            disconnectCompletion?()
            disconnectCompletion = nil
            self.stateChanged?()
            return
        }

        guard let vpnProtocol = currentVpnProtocol else {
            return
        }

        vpnStateConfiguration.determineActiveVpnState(vpnProtocol: vpnProtocol) { [weak self] result in
            guard let self = self, !self.quickReconnection else {
                return
            }

            switch result {
            case let .failure(error):
                self.setState(withError: error)
            case let .success((vpnManager, newState)):
                guard newState != self.state else {
                    return
                }

                switch newState {
                case .disconnecting:
                    self.quickReconnection = true
                    self.connectionQueue.asyncAfter(deadline: .now() + CoreAppConstants.UpdateTime.quickReconnectTime) {
                        let newState = self.vpnStateConfiguration.determineNewState(vpnManager: vpnManager)
                        switch newState {
                        case .connecting:
                            self.connectionQueue.asyncAfter(deadline: .now() + CoreAppConstants.UpdateTime.quickUpdateTime) {
                                self.updateState(vpnManager)
                            }
                        default:
                            self.updateState(vpnManager)
                        }
                    }
                default:
                    self.updateState(vpnManager)
                }
            }
        }
    }
    
    private func updateState(_ vpnManager: NEVPNManagerWrapper) {
        quickReconnection = false
        let newState = vpnStateConfiguration.determineNewState(vpnManager: vpnManager)
        guard newState != self.state else { return }
        self.state = newState
        //log.info("VPN update state to \(self.state.logDescription)", category: .connection, event: .change)
        
        switch self.state {
        case .connecting:
            if !self.connectAllowed {
                //log.info("VPN connection not allowed, will disconnect now.", category: .connection)
                self.disconnect {}
                return
            }
        case .error(let error):
            if case SysVPNError.tlsServerVerification = error {
                self.disconnect {}
               // self.alertService?.push(alert: MITMAlert(messageType: .vpn))
                break
            }
            if case SysVPNError.tlsInitialisation = error {
                self.disconnect {}
                break
            }
            fallthrough
        case .disconnected, .invalid:
            self.disconnectCompletion?()
            self.disconnectCompletion = nil
            setRemoteAuthenticationEndpoint(provider: nil)
            disconnectLocalAgent()
        case .connected:
            setRemoteAuthenticationEndpoint(provider: vpnManager.vpnConnection as? ProviderMessageSender)
            self.connectLocalAgent()
        default:
            break
        }

        self.stateChanged?()
    }
    
    private func setRemoteAuthenticationEndpoint(provider: ProviderMessageSender?) {
         
        
    }
    
    func disconnectLocalAgent() {
       
    }
    
    func connectLocalAgent() {
        
    }

    private func executeDisconnectionRequestWhenReady(request: @escaping () -> Void) {
        print("[VPN] call executeDisconnectionRequestWhenReady")
        if currentVpnProtocol == nil {
            delayedDisconnectRequest = request
        } else {
            request()
        }
    }
}