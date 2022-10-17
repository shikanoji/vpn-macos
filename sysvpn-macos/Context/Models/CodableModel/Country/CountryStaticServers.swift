//
//  CountryStaticServers.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CountryStaticServers: Codable {

  enum CodingKeys: String, CodingKey {
    case countryId
    case serverNumber
    case flag
    case latitude
    case cityName
    case iso2
    case currentLoad
    case longitude
    case x
    case countryName
    case iso3
    case serverId
    case y
  }

  var countryId: Int?
  var serverNumber: Int?
  var flag: String?
  var latitude: String?
  var cityName: String?
  var iso2: String?
  var currentLoad: Int?
  var longitude: String?
  var x: Double?
  var countryName: String?
  var iso3: String?
  var serverId: Int?
  var y: Double?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    countryId = try container.decodeIfPresent(Int.self, forKey: .countryId)
    serverNumber = try container.decodeIfPresent(Int.self, forKey: .serverNumber)
    flag = try container.decodeIfPresent(String.self, forKey: .flag)
    latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
    cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
    iso2 = try container.decodeIfPresent(String.self, forKey: .iso2)
    currentLoad = try container.decodeIfPresent(Int.self, forKey: .currentLoad)
    longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    x = try container.decodeIfPresent(Double.self, forKey: .x)
    countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
    iso3 = try container.decodeIfPresent(String.self, forKey: .iso3)
    serverId = try container.decodeIfPresent(Int.self, forKey: .serverId)
    y = try container.decodeIfPresent(Double.self, forKey: .y)
  }

}
