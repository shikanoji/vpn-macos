//
//  AuthResult.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AuthResult: Codable {
    enum CodingKeys: String, CodingKey {
        case tokens
        case user
    }

    var tokens: AuthTokens?
    var user: AuthUser?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokens = try container.decodeIfPresent(AuthTokens.self, forKey: .tokens)
        user = try container.decodeIfPresent(AuthUser.self, forKey: .user)
    }
}
