//
//  IPCFactory.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 16/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

enum IPCServiceProto: String {
  
    case openVPN = "com.syspvn.macos.openvpn"
    case wireGuard = "com.syspvn.macos.wireguard"
    
    public var machServiceName: String {
        let teamId = "J953BZ6B49"
        return "\(teamId).group.\(rawValue)"
    }
}

class IPCFactory {
    class func makeIPCService(proto: IPCServiceProto) -> XPCServiceUser {
        return XPCServiceUser(withExtension: proto.machServiceName, logger: { print("\($0)")
        })
    }
}
