//
//  CountryCity.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CountryCity: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case latitude
    case countryId
    case y
    case longitude
    case x
    case name
  }

  var id: Int?
  var latitude: String?
  var countryId: Int?
  var y: Float?
  var longitude: String?
  var x: Float?
  var name: String?

// custom field
   var country: CountryAvailables?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
    countryId = try container.decodeIfPresent(Int.self, forKey: .countryId)
    y = try container.decodeIfPresent(Float.self, forKey: .y)
    longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    x = try container.decodeIfPresent(Float.self, forKey: .x)
    name = try container.decodeIfPresent(String.self, forKey: .name)
  }

}
