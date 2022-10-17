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
    func connectedDate(completion: @escaping (Date?) -> Void)
    
    func checkNetworkConditionsAndCredentialsAndConnect(withConfiguration configuration: ConnectionConfiguration)
}

class SysVpnAppStateManagement : AppStateManagement {
    private var attemptingConnection = false
    var state: AppState = .disconnected
    private var vpnManager: SysVPNManagerProtocol
    
    var onVpnStateChanged: ((VpnState) -> Void)?
    
    var displayState: AppDisplayState = .disconnected
    
    init(vpnManager: SysVPNManagerProtocol) {
        self.vpnManager = vpnManager
    }
    
    func isOnDemandEnabled(handler: @escaping (Bool) -> Void) {
        
    }
    
    func cancelConnectionAttempt() {
        
    }
    
    func cancelConnectionAttempt(completion: @escaping () -> Void) {
        
    }
    
    func prepareToConnect() {
        
    }
    
    func disconnect() {
        
    }
    
    func disconnect(completion: @escaping () -> Void) {
        
    }
    
    func refreshState() {
        vpnManager.refreshState()
    }
    
    func connectedDate(completion: @escaping (Date?) -> Void) {
        
    }
    
    
    func checkNetworkConditionsAndCredentialsAndConnect(withConfiguration configuration: ConnectionConfiguration) {
        
        if case AppState.aborted = state { return }
        
        //To-do: check reachability
        //...
        
        
        attemptingConnection = true
        
        //To-do: check config outdate
        // ..
        
        configureVPNManagerAndConnect(configuration)
    }
    
    func configureVPNManagerAndConnect( _ configuration: ConnectionConfiguration ) {
        let vpnManagerConfiguration = SysVPNConfiguration(username: "", password: "", adapterTitle: "sysvpn", connection: configuration.connectionDetermine.connectionString, vpnProtocol: configuration.connectionDetermine.vpnProtocol, passwordReference: Data())
        vpnManager.disconnectAnyExistingConnectionAndPrepareToConnect(with: vpnManagerConfiguration) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.vpnManager.setOnDemand(false)
            })
        }
    }
    
    
}
