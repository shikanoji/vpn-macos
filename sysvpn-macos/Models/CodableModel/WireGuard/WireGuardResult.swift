//
//  WireGuardResult.swift
//
//  Created by doragon on 21/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct WireGuardResult: Codable {

  enum CodingKeys: String, CodingKey {
    case interface = "Interface"
    case server
    case peer = "Peer"
    case sessionId
  }

  var interface: WireGuardInterface?
  var server: VPNServer?
  var peer: WireGuardPeer?
  var sessionId: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    interface = try container.decodeIfPresent(WireGuardInterface.self, forKey: .interface)
    server = try container.decodeIfPresent(VPNServer.self, forKey: .server)
    peer = try container.decodeIfPresent(WireGuardPeer.self, forKey: .peer)
    sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId)
  }
    
    func parseVpnConfig() -> String {
        guard let _interface = interface, let _peer = peer else {
            return ""
        }
        
        var connStr = ""
        let spaceLine = "\n"
        connStr += "[Interface]"
        connStr += spaceLine
        
        connStr += "Address = "
        connStr += _interface.address ?? ""
        connStr += spaceLine
        
        connStr += "PrivateKey = "
        connStr += _interface.privateKey ?? ""
        connStr += spaceLine
        
        connStr += "DNS = "
        connStr += _interface.dNS ?? ""
        connStr += spaceLine
        
        connStr += "[Peer]"
        connStr += spaceLine
        
        connStr += "PublicKey = "
        connStr += _peer.publicKey ?? ""
        connStr += spaceLine
        
        connStr += "Endpoint = "
        connStr += _peer.endpoint ?? ""
        connStr += spaceLine
        
        connStr += "AllowedIPs = "
        connStr += _peer.allowedIPs ?? ""
        connStr += spaceLine
        
        return connStr
    }

}
