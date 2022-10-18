//
//  VpnParamRequest.swift
//  sysvpn-macos
//
//  Created by doragon on 10/10/2022.
//

import Foundation

enum VpnTypeConnect {
    case ovpn
    case wg
    
    var vpnTypeStr: String {
        switch self {
        case .ovpn:
            return "ovpn"
        case .wg:
            return "wg"
        }
    }
    
}

class VpnParamRequest {
    
    var proto: String?
    var dev: String?
    var countryId: Int?
    var prevSessionId: String?
    var serverId: Int?
    var cityId: Int?
    var isHop: Int?
    var tech: VpnTypeConnect?
    var cybersec: Int?
     
}
