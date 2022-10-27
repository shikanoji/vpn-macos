//
//  CountryOrder.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CountryOrder: Codable {
    enum CodingKeys: String, CodingKey {
        case fields
        case direction
    }

    var fields: [String]?
    var direction: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fields = try container.decodeIfPresent([String].self, forKey: .fields)
        direction = try container.decodeIfPresent(String.self, forKey: .direction)
    }
}
