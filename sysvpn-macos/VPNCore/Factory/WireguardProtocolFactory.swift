//
//  WireguardProtocolFactory.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import TunnelKitWireGuardCore
import TunnelKitWireGuardAppExtension
import WireGuardKit
import TunnelKitWireGuardManager
import Foundation
import NetworkExtension

class WireguardProtocolFactory {

    private let bundleId: String
    private let appGroup: String
    private let vpnManagerFactory: NETunnelProviderManagerWrapperFactory

    private var vpnManager: NETunnelProviderManagerWrapper?
    
    public init(bundleId: String,
                appGroup: String,
                vpnManagerFactory: NETunnelProviderManagerWrapperFactory) {
        self.bundleId = bundleId
        self.appGroup = appGroup
        self.vpnManagerFactory = vpnManagerFactory
    }
        
    open func logs(completion: @escaping (String?) -> Void) {
        guard let fileUrl = logFile() else {
            completion(nil)
            return
        }
        do {
            let log = try String(contentsOf: fileUrl)
            completion(log)
        } catch {
           // log.error("Error reading WireGuard log file", category: .app, metadata: ["error": "\(error)"])
            completion(nil)
        }
    }
}


extension WireguardProtocolFactory: VpnProtocolFactory {
     func create(_ configuration: SysVpnManagerConfiguration) throws -> NEVPNProtocol { 
         return try getWireguardConfig(for: configuration).asTunnelProtocol(withBundleIdentifier: bundleId, extra: configuration.extra)
    }
    
     func vpnProviderManager(for requirement: VpnProviderManagerRequirement, completion: @escaping (NEVPNManagerWrapper?, Error?) -> Void) {
        if requirement == .status, let vpnManager = vpnManager {
            completion(vpnManager, nil)
        } else {
            vpnManagerFactory.tunnelProviderManagerWrapper(forProviderBundleIdentifier: self.bundleId) { manager, error in
                if let manager = manager {
                    self.vpnManager = manager
                }
                completion(manager, error)
            }
        }
    }
    
    private func logFile() -> URL? {
        guard let sharedFolderURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            //log.error("Cannot obtain shared folder URL for appGroup", category: .app, metadata: ["appGroupId": "\(appGroup)", "protocol": "WireGuard"])
            return nil
        }
        return sharedFolderURL.appendingPathComponent(CoreAppConstants.LogFiles.wireGuard)
    }
 

    
     func getWireguardConfig(for configuration: SysVpnManagerConfiguration) throws -> WireGuard.ProviderConfiguration {
         var cfg = try WireGuard.Configuration(wgQuickConfig: configuration.connection)
         return WireGuard.ProviderConfiguration("WireGuard", appGroup: appGroup, configuration: cfg)
    }
}
