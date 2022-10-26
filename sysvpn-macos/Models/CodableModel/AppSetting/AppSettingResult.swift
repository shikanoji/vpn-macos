//
//  Result.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AppSettingResult: Codable {

  enum CodingKeys: String, CodingKey {
      case ipInfo
      case appSettings
      case lastChange
  }
    
    var ipInfo: AppSettingIpInfo?
    var appSettings: AppSettings?
    var lastChange: Double?



  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      ipInfo = try container.decodeIfPresent(AppSettingIpInfo.self, forKey: .ipInfo)
      appSettings = try container.decodeIfPresent(AppSettings.self, forKey: .appSettings)
      lastChange = Double( (try? container.decodeIfPresent(Int64.self, forKey: .lastChange)) ?? 0) / 1000
  }
    
    
    func saveUserSetting() {
        self.saveFile(fileName: .keySaveUserSetting)
    }
    
    static func getUserSetting() -> AppSettingResult?{
        return AppSettingResult.readFile(fileName: .keySaveUserSetting) as? AppSettingResult
    }
    

}
