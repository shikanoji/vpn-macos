//
//  AuthRefresh.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AuthRefresh: Codable {

  enum CodingKeys: String, CodingKey {
    case token
    case expires
  }

  var token: String?
  var expires: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    token = try container.decodeIfPresent(String.self, forKey: .token)
    expires = try container.decodeIfPresent(Int.self, forKey: .expires)
  }

}
