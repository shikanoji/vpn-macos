//
//  Result.swift
//
//  Created by doragon on 18/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ServerStateResult: Codable {

  enum CodingKeys: String, CodingKey {
    case listServer = "rows"
    case count
  }

  var listServer: [ListServerState]?
  var count: Int?

  init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      listServer = try container.decodeIfPresent([ListServerState].self, forKey: .listServer)
      count = try container.decodeIfPresent(Int.self, forKey: .count)
  }
    
    func updateStarCountry() {
        var coutryResult = AppDataManager.shared.userCountry
        var newListServer = [CountryStaticServers]()
        guard let listData = listServer else {
            return
        }
        for server in listData {
            var item = coutryResult?.staticServers?.filter({ data in
                return data.serverId == server.serverId
            }).first
            if item != nil {
                item?.serverId = server.serverId
                newListServer.append(item!)
            }
        }
        coutryResult?.staticServers = newListServer
        AppDataManager.shared.userCountry = coutryResult
    }

}
