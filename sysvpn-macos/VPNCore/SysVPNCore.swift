//
//  SysVPNCore.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 01/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation


class SysVPNCore : SysVPNGatewayProtocol {

    var connection: ConnectionStatus = .disconnected
    
    static let connectionChanged = Notification.Name("VpnGatewayConnectionChanged")
    static let activeServerTypeChanged = Notification.Name("VpnGatewayActiveServerTypeChanged")
    static let needsReconnectNotification = Notification.Name("VpnManagerNeedsReconnect")
    var lastConnectionConiguration:  ConnectionConfiguration?
    var vpnService: SysVPNService
    var appStateManager: AppStateManagement
    init(vpnService : SysVPNService, appStateManager: AppStateManagement ) {
        self.vpnService = vpnService
        self.appStateManager = appStateManager
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appStateChanged),
                                               name: AppStateManagerNotification.stateChange,
                                               object: nil)
    }
    
    func autoConnect() {
        appStateManager.isOnDemandEnabled { [weak self] enabled in
            guard let self = self, !enabled else {
                return
            }
            self.quickConnect()
        }
    }
    
    func quickConnect() {
        connect(with: quickConnectConnectionRequest())
    }
    
    func quickConnectConnectionRequest() -> SysVPNConnectionRequest {
        return SysVPNConnectionRequest(connectType: .quick)
    }
    
    func connectTo(connectType: ConnectionType, params: SysVPNConnectParams?) {
        let request = SysVPNConnectionRequest(connectType: connectType, params: params)
        connect(with: request)
    }
    
    func retryConnection() {
        let lastSessionCode: String = ""
        connectTo(connectType: .lastSessionCode(code: lastSessionCode), params: nil)
    }
    
    func connect(with request: SysVPNConnectionRequest) {
        print("[VPN-Core] start connect vpn")
        DispatchQueue.main.async {
            self.appStateManager.prepareToConnect()
        }
        vpnService.prepareConection(connectType: request.connectType, params: request.params, callback: { response in
            switch response {
            case .failure( let e ):
                print("[VPN-Core] request determine vpn config failed \(e) ")
                DispatchQueue.main.async { [weak self] in
                    //To-do: push error
                    self?.disconnect()
                }
            case .success(let result):
                let connectionConfig = ConnectionConfiguration(connectionDetermine: result, connectionParam: request.params, vpnProtocol: result.vpnProtocol)
                self.lastConnectionConiguration = connectionConfig
                print("[VPN-Core] request determine vpn config success")
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
            self.vpnService.disconnectLastSession(disconnectParam: self.lastConnectionConiguration?.connectionDetermine.disconnectParam) {  response in
                switch response {
                case .success( _ ):
                    print("disconnect call success")
                case .failure(let error):
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
    
    
}
