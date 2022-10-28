//
//  AuthTokens.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AuthTokens: Codable {
    enum CodingKeys: String, CodingKey {
        case refresh
        case access
    }

    var refresh: AuthRefresh?
    var access: AuthAccess?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refresh = try container.decodeIfPresent(AuthRefresh.self, forKey: .refresh)
        access = try container.decodeIfPresent(AuthAccess.self, forKey: .access)
    }
}
