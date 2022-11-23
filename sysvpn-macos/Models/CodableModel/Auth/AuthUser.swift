//
//  User.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AuthUser: Codable {
    enum CodingKeys: String, CodingKey {
        case emailVerified = "email_verified"
        case premiumExpire = "premium_expire"
        case createdAt = "created_at"
        case id
        case status
        case isDeleted = "is_deleted"
        case isPremium = "is_premium"
        case email
        case updatedAt = "updated_at"
        case freePremiumDays = "free_premium_days"
        case hasPassword = "has_password"
    }

    var emailVerified: Bool?
    var premiumExpire: Int?
    var createdAt: Int?
    var id: Int?
    var status: Int?
    var isDeleted: Int?
    var isPremium: Bool?
    var email: String?
    var updatedAt: Int?
    var freePremiumDays: Int?
    var hasPassword: Bool?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        emailVerified = try container.decodeIfPresent(Bool.self, forKey: .emailVerified)
        premiumExpire = try container.decodeIfPresent(Int.self, forKey: .premiumExpire)
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        isDeleted = try container.decodeIfPresent(Int.self, forKey: .isDeleted)
        isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        freePremiumDays = try container.decodeIfPresent(Int.self, forKey: .freePremiumDays)
        hasPassword = try container.decodeIfPresent(Bool.self, forKey: .hasPassword)
    }
     
    static func fromSaved() -> AuthUser? {
        return AuthUser.readFile(fileName: .keySaveUserData) as? AuthUser
    }
    
    func save() {
        saveFile(fileName: .keySaveUserData)
    }
    
    var dayPreniumLeft: Int {
        let now = max(0, Double(premiumExpire ?? 0) - Date.now.timeIntervalSince1970)
        return Int(now / 86400)
    }
}
