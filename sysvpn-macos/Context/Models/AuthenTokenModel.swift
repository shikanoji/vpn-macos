//
//  AuthenTokenModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/09/2022.
//

import Foundation
import SwiftyJSON

class AuthenTokenModel : BaseModel {
    var access: JWTTokenModel?
    var refresh: JWTTokenModel?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        access = JWTTokenModel(json: json[JSONTokenKey.access])
        refresh = JWTTokenModel(json: json[JSONTokenKey.refresh])
    }
     
}

class JWTTokenModel : BaseModel {
    var token: String?
    var expires: Int?
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        token = json[JSONTokenKey.access].string
        expires = json[JSONTokenKey.refresh].int
    }
}

struct JSONTokenKey {

    static let tokens = "tokens"
    static let access = "access"
    static let refresh = "refresh"
    static let token = "token"
    static let expires = "expires"
    
}
