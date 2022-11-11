//
//  WireGuardInterface.swift
//
//  Created by doragon on 21/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct WireGuardInterface: Codable {
    enum CodingKeys: String, CodingKey {
        case dNS = "DNS"
        case privateKey = "PrivateKey"
        case address = "Address"
    }

    var dNS: String?
    var privateKey: String?
    var address: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dNS = try container.decodeIfPresent(String.self, forKey: .dNS)
        privateKey = try container.decodeIfPresent(String.self, forKey: .privateKey)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }
}
