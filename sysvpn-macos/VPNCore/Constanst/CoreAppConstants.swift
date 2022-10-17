//
//  CoreAppConstants.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation


import Foundation

public class CoreAppConstants {
         
    struct LogFiles {
        static var openVpn = "debug.log"
        static var wireGuard = "WireGuard.log"
    }
    
    struct UpdateTime {
        static let quickUpdateTime: TimeInterval = 3.0
        static let quickReconnectTime: TimeInterval = 0.5
        static let announcementRefreshTime: TimeInterval = 12 * 60 * 60
    }
    
    static var appBundleId: String = (Bundle.main.bundleIdentifier ?? "om.syspvn.client.macos").asMainAppBundleIdentifier
    
    struct AppGroups {
        static let main = "J953BZ6B49.group.com.syspvn.macos"
        static let teamId = "J953BZ6B49"
    }
     
    struct NetworkExtensions {
        static let openVpn = "\(appBundleId).OpenVpnSysExtension"
        static let wireguard = "\(appBundleId).WireGuardSysExtension"
    }
     
}

extension String {
    var asMainAppBundleIdentifier: String {
        var result = self.replacingOccurrences(of: ".widget", with: "")
        result = result.replacingOccurrences(of: ".OpenVpnSysExtension", with: "")
        result = result.replacingOccurrences(of: ".WireGuardSysExtension", with: "")
        return result
    }
}
