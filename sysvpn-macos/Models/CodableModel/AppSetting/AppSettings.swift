//
//  AppSettings.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AppSettings: Codable {

  enum CodingKeys: String, CodingKey {
    case forceUpdateVersions
    case settingVpn = "vpn"
  }

  var forceUpdateVersions: [Int]?
  var settingVpn: AppSettingVpn? 

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    forceUpdateVersions = try container.decodeIfPresent([Int].self, forKey: .forceUpdateVersions)
    settingVpn = try container.decodeIfPresent(AppSettingVpn.self, forKey: .settingVpn)
  }

}
