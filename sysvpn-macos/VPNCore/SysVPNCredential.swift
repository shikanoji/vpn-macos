//
//  SysVPNCredential.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import NetworkExtension
import TunnelKitManager

protocol SysVPNCredentialsConfiguratorFactory {
    func getCredentialsConfigurator(for protocol: VpnProtocol) -> VpnCredentialsConfigurator
}

protocol VpnCredentialsConfigurator {
    func prepareCredentials(for protocolConfig: NEVPNProtocol, configuration: SysVpnManagerConfiguration, completionHandler: @escaping (NEVPNProtocol) -> Void)
}

final class OVPNiOSCredentialsConfigurator: VpnCredentialsConfigurator {
    func prepareCredentials(for protocolConfig: NEVPNProtocol, configuration: SysVpnManagerConfiguration, completionHandler: @escaping (NEVPNProtocol) -> Void) {
        protocolConfig.username = configuration.username // Needed to detect connections started from another user (see AppSessionManager.resolveActiveSession)
                 
        let storage = TunnelKitManager.Keychain(group: CoreAppConstants.AppGroups.main)
        try? storage.set(password: configuration.password, for: configuration.username, context: CoreAppConstants.NetworkExtensions.openVpn)
        
        completionHandler(protocolConfig)
    }
}

final class WGiOSVpnCredentialsConfigurator: VpnCredentialsConfigurator {
    init() {}
    
    func prepareCredentials(for protocolConfig: NEVPNProtocol, configuration: SysVpnManagerConfiguration, completionHandler: @escaping (NEVPNProtocol) -> Void) {
        protocolConfig.username = configuration.username
                
        /* let keychain = VpnKeychain()
         protocolConfig.passwordReference = try? keychain.store(wireguardConfiguration: configuration.asWireguardConfiguration(config: propertiesManager.wireguardConfig))
         */
        completionHandler(protocolConfig)
    }
}

final class MacosVpnCredentialsConfiguratorFactory: SysVPNCredentialsConfiguratorFactory {
    init() {}
    
    func getCredentialsConfigurator(for vpnProtocol: VpnProtocol) -> VpnCredentialsConfigurator {
        switch vpnProtocol {
        case .openVpn:
            return OVPNiOSCredentialsConfigurator()
        case .wireGuard:
            return WGiOSVpnCredentialsConfigurator()
        }
    }
}
