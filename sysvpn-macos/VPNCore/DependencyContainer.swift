//
//  DependencyContainer.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import NetworkExtension
 
class DependencyContainer {
    
    static let shared = DependencyContainer()
     
    private let vpnCredentialsConfiguratorFactory = MacosVpnCredentialsConfiguratorFactory()
    
    private lazy var sysVpnStateMgr = SysVPNStateConfigurationManager(openVpnProtocolFactory: openVpnProtocolFactory, wireguardProtocolFactory: wireguardProtocolFactory, appGroup:  CoreAppConstants.AppGroups.main)
    
    lazy var openVpnProtocolFactory: VpnProtocolFactory = OpenVpnProtocolFactory( appGroup: CoreAppConstants.AppGroups.main, vpnManagerFactory: self)
    
    lazy var wireguardProtocolFactory: VpnProtocolFactory  = WireguardProtocolFactory( appGroup: CoreAppConstants.AppGroups.main, vpnManagerFactory: self )
    
    lazy var vpnManager: SysVPNManagerProtocol = SysVPNManager(appGroup: CoreAppConstants.AppGroups.main, vpnCredentialsConfiguratorFactory: vpnCredentialsConfiguratorFactory, openVpnProtocolFactory: openVpnProtocolFactory, wireguardProtocolFactory: wireguardProtocolFactory, vpnStateConfiguration: sysVpnStateMgr)
    
    lazy var appStateMgr = SysVpnAppStateManagement(vpnManager: makeVpnManager() as! SysVPNManager)
    
    lazy var vpnCore = SysVPNCore(vpnService: makeVpnService(), appStateManager: appStateMgr)
}

extension DependencyContainer: SysVPNManagerFactory {
    func makeVpnManager() -> SysVPNManagerProtocol {
        return vpnManager
    }
     
}

extension DependencyContainer: NETunnelProviderManagerWrapperFactory {
    func makeNewManager() -> NETunnelProviderManagerWrapper {
        NETunnelProviderManager()
    }

    func loadManagersFromPreferences(completionHandler: @escaping ([NETunnelProviderManagerWrapper]?, Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            completionHandler(managers, error)
        }
    }
}

extension DependencyContainer: SysVPNStateConfigurationFactory {
    func makeVpnStateConfiguration() -> SysVPNStateConfiguration {
        return sysVpnStateMgr
    }
}


extension DependencyContainer: SysVPNServiceFactory {
    func makeVpnService() -> SysVPNService {
        return AppVpnService()  
    }
}
