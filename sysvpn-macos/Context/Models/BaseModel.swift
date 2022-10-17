//
//  BaseModel.swift
//  sysvpn-macos
//
//  Created by doragon on 15/09/2022.
//

import Foundation
import SwiftyJSON
protocol BaseModel {
    init?(json: JSON?)
}

class BaseResponseModel<T: BaseModel>: BaseModel {
    var success: Bool?
    var message: String?
    var result: T?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        success = json[JSONBaseModelKey.success].bool
        message = json[JSONBaseModelKey.message].string
        result = T(json: json[JSONBaseModelKey.result])
    }
}

struct JSONBaseModelKey {
    static let success = "success"
    static let message = "message"
    static let result = "result"
}


