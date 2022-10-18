//
//  Vpn.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AppSettingVpn: Codable {

  enum CodingKeys: String, CodingKey {
    case defaultTech
    case defaultProtocol
  }

  var defaultTech: String?
  var defaultProtocol: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    defaultTech = try container.decodeIfPresent(String.self, forKey: .defaultTech)
    defaultProtocol = try container.decodeIfPresent(String.self, forKey: .defaultProtocol)
  }

}
