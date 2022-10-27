//
//  WireGuardPeer.swift
//
//  Created by doragon on 21/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct WireGuardPeer: Codable {
    enum CodingKeys: String, CodingKey {
        case allowedIPs = "AllowedIPs"
        case endpoint = "Endpoint"
        case persistentKeepalive = "PersistentKeepalive"
        case publicKey = "PublicKey"
    }

    var allowedIPs: String?
    var endpoint: String?
    var persistentKeepalive: Int?
    var publicKey: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allowedIPs = try container.decodeIfPresent(String.self, forKey: .allowedIPs)
        endpoint = try container.decodeIfPresent(String.self, forKey: .endpoint)
        persistentKeepalive = try container.decodeIfPresent(Int.self, forKey: .persistentKeepalive)
        publicKey = try container.decodeIfPresent(String.self, forKey: .publicKey)
    }
}
