//
//  VPNServer.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct VPNServer: Codable {
    enum CodingKeys: String, CodingKey {
        case ipAddress
        case cityId
        case currentLoad
        case id
    }

    var ipAddress: String?
    var cityId: Int?
    var currentLoad: Int?
    var id: Int?

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress)
        cityId = try container.decodeIfPresent(Int.self, forKey: .cityId)
        currentLoad = try container.decodeIfPresent(Int.self, forKey: .currentLoad)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }
}
