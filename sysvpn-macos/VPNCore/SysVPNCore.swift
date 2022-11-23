//
//  SysVPNCore.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 01/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

class SysVPNCore: SysVPNGatewayProtocol {
    var connection: ConnectionStatus = .disconnected
    
    static let connectionChanged = Notification.Name("VpnGatewayConnectionChanged")
    static let activeServerTypeChanged = Notification.Name("VpnGatewayActiveServerTypeChanged")
    static let needsReconnectNotification = Notification.Name("VpnManagerNeedsReconnect")
    
    var lastConnectionConiguration: ConnectionConfiguration? {
        set {
            newValue.saveUserDefault(keyUserDefault: "lastConnectionConiguration")
        }
        get {
            return ConnectionConfiguration.readUserDefault(keyUserDefault: "lastConnectionConiguration")
        }
    }
    
    var vpnService: SysVPNService
    var appStateManager: AppStateManagement
    init(vpnService: SysVPNService, appStateManager: AppStateManagement) {
        self.vpnService = vpnService
        self.appStateManager = appStateManager
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appStateChanged),
                                               name: AppStateManagerNotification.stateChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectOnNotification),
                                               name: Self.needsReconnectNotification,
                                               object: nil)
    }
    
    func autoConnect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self._checkAutoConnect()
        }
    }
    
    func _checkAutoConnect() {
        if connection == .disconnected {
            appStateManager.isOnDemandEnabled { [weak self] enabled in
                guard let self = self, !enabled else {
                    return
                }
                if let lastConfig = self.lastConnectionConiguration, let id = lastConfig.serverInfo.id {
                    self.connectTo(connectType: .serverId(id: id), params: self.lastConnectionConiguration?.connectionParam)
                } else {
                    self.quickConnect()
                }
            }
        }
    }
    
    func quickConnect() {
        connect(with: quickConnectConnectionRequest())
    }
    
    func quickConnectConnectionRequest() -> SysVPNConnectionRequest {
        return SysVPNConnectionRequest(connectType: .quick, params: SysVPNConnectParams(isHop: false))
    }
    
    func connectTo(connectType: ConnectionType, params: SysVPNConnectParams?, isRetry: Bool = false) {
        let request = SysVPNConnectionRequest(connectType: connectType, params: params, retry: isRetry)
        connect(with: request)
    }
    
    func retryConnection(_ time: Int) {
        if let  lastSessionCode = self.lastConnectionConiguration?.connectionDetermine.disconnectParam?.sessionId,  let id = self.lastConnectionConiguration?.serverInfo.id {
            connectTo(connectType: .lastSessionCode(code: lastSessionCode, id: id ), params: nil, isRetry: true)
        }
    }
    
    func connect(with request: SysVPNConnectionRequest) {
        print("[VPN-Core] start connect vpn")
        if !request.retry {
            DispatchQueue.main.async {
                self.appStateManager.prepareToConnect()
            }
            PropertiesManager.shared.intentionallyDisconnected = false
        } else {
            PropertiesManager.shared.intentionallyDisconnected = true
        }
        vpnService.prepareConection(connectType: request.connectType, params: request.params, callback: { response in
            switch response {
            case let .failure(e):
                print("[VPN-Core] request determine vpn config failed \(e) ")
                if !request.retry {
                    DispatchQueue.main.async { [weak self] in
                        // To-do: push error
                        self?.stopConnecting(userInitiated: false)
                    }
                }
            case let .success(result):
                let connectionConfig = ConnectionConfiguration(connectionDetermine: result, connectionParam: request.params, vpnProtocol: result.vpnProtocol, serverInfo: result.serverInfo, isRetry: request.retry)
                self.lastConnectionConiguration = connectionConfig
                if result.vpnProtocol == .wireGuard {
                    PropertiesManager.shared.lastWireguardConnection = connectionConfig
                } else {
                    PropertiesManager.shared.lastOpenVpnConnection = connectionConfig
                }
                print("[VPN-Core] request determine vpn config success")
                IPCFactory.makeIPCRequestService().setProtocol(result.vpnProtocol.name)
                DispatchQueue.main.async { [weak self] in
                    self?.appStateManager.checkNetworkConditionsAndCredentialsAndConnect(withConfiguration: connectionConfig)
                }
            }
             
        })
    }
    
    func stopConnecting(userInitiated: Bool) {
        appStateManager.cancelConnectionAttempt()
    }
    
    public func disconnect() {
        disconnect {}
    }
    
    func disconnect(completion: @escaping () -> Void) {
        let completionWrapper: () -> Void = { [weak self] in
            completion()
            
            guard let self = self else {
                return
            }
            self.vpnService.disconnectLastSession(disconnectParam: self.lastConnectionConiguration?.connectionDetermine.disconnectParam) { response in
                switch response {
                case .success:
                    print("disconnect call success")
                case let .failure(error):
                    print("disconnect call failes \(error)")
                }
            }
        }
        
        appStateManager.disconnect(completion: completionWrapper)
    }
    
    func postConnectionInformation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            NotificationCenter.default.post(name: SysVPNCore.connectionChanged,
                                            object: self.connection,
                                            userInfo: [AppState.appStateKey: self.appStateManager.state])
        }
    }
    
    @objc private func appStateChanged(_ notification: Notification) {
        guard let state = notification.object as? AppState else {
            return
        }
        connection = ConnectionStatus.forAppState(state)
        postConnectionInformation()
    }
    
    @objc private func reconnectOnNotification(_: Notification) {}
}
