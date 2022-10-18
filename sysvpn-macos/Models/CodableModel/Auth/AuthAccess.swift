//
//  AuthAccess.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AuthAccess: Codable {

  enum CodingKeys: String, CodingKey {
    case expires
    case token
  }

  var expires: Int?
  var token: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    expires = try container.decodeIfPresent(Int.self, forKey: .expires)
    token = try container.decodeIfPresent(String.self, forKey: .token)
  }

}
