//
//  CountrySettings.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CountrySettings: Codable {
    enum CodingKeys: String, CodingKey {
        case order
    }

    var order: CountryOrder?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decodeIfPresent(CountryOrder.self, forKey: .order)
    }
}
