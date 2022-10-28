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
        guard let listData = listServer else {
            return
        }
        let length = coutryResult?.staticServers?.count ?? 0
        
        for i in 0..<length {
            let data = listData.filter { item in
                return item.serverId == coutryResult?.staticServers![i].serverId
            }.first
            if data != nil {
                coutryResult?.staticServers![i].score = data?.score
            }
        }
        AppDataManager.shared.userCountry = coutryResult
    }
}
