//
//  Rows.swift
//
//  Created by doragon on 18/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ListServerState: Codable {

  enum CodingKeys: String, CodingKey {
    case serverId
    case score
  }

  var serverId: Int?
  var score: Int? 

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    serverId = try container.decodeIfPresent(Int.self, forKey: .serverId)
    score = try container.decodeIfPresent(Int.self, forKey: .score)
  }

}
