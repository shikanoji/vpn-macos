//
//  MultiHopEntry.swift
//
//  Created by doragon on 24/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct MultiHopEntry: Codable {
    enum CodingKeys: String, CodingKey {
        case country
        case city
        case serverId
    }

    var country: CountryAvailables?
    var city: CountryCity?
    var serverId: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decodeIfPresent(CountryAvailables.self, forKey: .country)
        city = try container.decodeIfPresent(CountryCity.self, forKey: .city)
        serverId = try container.decodeIfPresent(Int.self, forKey: .serverId)
    }
}
