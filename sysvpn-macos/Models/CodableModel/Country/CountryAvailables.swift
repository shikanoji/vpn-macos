//
//  CountryAvailableCountries.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

class CountryAvailables: Codable {

  enum CodingKeys: String, CodingKey {
    case region
    case latitude
    case iso2
    case x
    case city
    case y
    case subRegion
    case longitude
    case name
    case flag
    case iso3
    case id
  }

  var region: String?
  var latitude: String?
  var iso2: String?
  var x: Double?
  var city: [CountryCity]?
  var y: Double?
  var subRegion: String?
  var longitude: String?
  var name: String?
  var flag: String?
  var iso3: String?
  var id: Int?
    

 // custom
    var cacheNode: NodePoint?
    var lastUse: Date?
    
   required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    region = try container.decodeIfPresent(String.self, forKey: .region)
    latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
    iso2 = try container.decodeIfPresent(String.self, forKey: .iso2)
    x = try container.decodeIfPresent(Double.self, forKey: .x)
    city = try container.decodeIfPresent([CountryCity].self, forKey: .city)
    y = try container.decodeIfPresent(Double.self, forKey: .y)
    subRegion = try container.decodeIfPresent(String.self, forKey: .subRegion)
    longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    flag = try container.decodeIfPresent(String.self, forKey: .flag)
    iso3 = try container.decodeIfPresent(String.self, forKey: .iso3)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
  }

}
