//
//  UserModel.swift
//  sysvpn-macos
//
//  Created by doragon on 15/09/2022.
//

import Foundation
import SwiftyJSON

class AuthenResponse: BaseModel {
    var user: UserModel?
    var tokens: AuthenTokenModel?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        user = UserModel(json: json[JSONUserKey.user])
        tokens = AuthenTokenModel(json: json[JSONTokenKey.tokens])
    }
    
}



class UserModel: BaseModel {
    var id: Int?
    var email: String?
    var status: Int?
    var premiumExpire: Int?
    var emailVerified: Bool?
    var isDelete: Int?
    var veryfiedAt: Int?
    var freePremiumDays: Int?
    var isPremium: Bool?
    var hasPassword: Bool?
     
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        id = json[JSONUserKey.id].int
        email = json[JSONUserKey.email].string
        status = json[JSONUserKey.status].int
        premiumExpire = json[JSONUserKey.premiumExpire].int
        emailVerified = json[JSONUserKey.emailVerified].bool
        isDelete = json[JSONUserKey.isDelete].int
        veryfiedAt = json[JSONUserKey.veryfiedAt].int
        freePremiumDays = json[JSONUserKey.freePremiumDays].int
        isPremium = json[JSONUserKey.isPremium].bool
        hasPassword = json[JSONUserKey.hasPassword].bool
    }
    
    static func fromSaved() -> UserModel? {
        if let dicData = UserDefaults.standard.dictionary(forKey: .keySaveUserData) {
            let model = UserModel()
            model.id = dicData[JSONUserKey.id] as? Int ?? 0
            model.email = dicData[JSONUserKey.email] as? String
            model.status = dicData[JSONUserKey.status] as? Int
            model.premiumExpire = dicData[JSONUserKey.premiumExpire] as? Int
            model.emailVerified = dicData[JSONUserKey.emailVerified] as? Bool ?? false
            model.isDelete = dicData[JSONUserKey.isDelete] as? Int ?? 0
            model.veryfiedAt = dicData[JSONUserKey.veryfiedAt] as? Int
            model.freePremiumDays = dicData[JSONUserKey.freePremiumDays] as? Int ?? 0
            model.isPremium = dicData[JSONUserKey.isPremium] as? Bool ?? false
            model.hasPassword = dicData[JSONUserKey.hasPassword] as? Bool ?? false
         
            return model
        }
      
        return nil
    }
    
    func save() {
        let dicData: [String: Any] = [
            JSONUserKey.id: id,
            JSONUserKey.email: email ?? "",
            JSONUserKey.status: status ?? 0,
            JSONUserKey.premiumExpire: premiumExpire ?? 0,
            JSONUserKey.emailVerified: emailVerified ?? false,
            JSONUserKey.isDelete: isDelete ?? 0,
            JSONUserKey.veryfiedAt: veryfiedAt ?? 0,
            JSONUserKey.freePremiumDays: freePremiumDays ?? 0,
            JSONUserKey.isPremium: isPremium ?? false,
            JSONUserKey.hasPassword: hasPassword ?? false
        ]
      
        UserDefaults.standard.setValue(dicData, forKey: .keySaveUserData)
    }
}
   
extension String {
    static var keySaveUserData = "KEY_USER_DATA"
}

struct JSONUserKey {
    static let id = "id"
    static let email = "email"
    static let status = "status"
    static let premiumExpire = "premium_expire"
    static let emailVerified = "email_verified"
    static let isDelete = "is_deleted"
    static let createAt = "created_at"
    static let updateAt = "updated_at"
    static let veryfiedAt = "verified_at"
    static let freePremiumDays = "free_premium_days"
    static let isPremium = "is_premium"
    static let hasPassword = "has_password"
    static let user = "user"

}
