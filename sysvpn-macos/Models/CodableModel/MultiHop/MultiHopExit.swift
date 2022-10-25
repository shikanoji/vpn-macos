//
//  MultiHopExit.swift
//
//  Created by doragon on 24/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct MultiHopExit: Codable {

  enum CodingKeys: String, CodingKey {
    case country
    case city
  }

  var country: CountryAvailables?
  var city: CountryCity?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    country = try container.decodeIfPresent(CountryAvailables.self, forKey: .country)
    city = try container.decodeIfPresent(CountryCity.self, forKey: .city)
  }

}
