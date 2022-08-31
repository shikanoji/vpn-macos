//
//  Constant.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 31/08/2022.
//

import Foundation
struct Constant {
    struct API {
        #if DEBUG
            static let root = "https://api.sysvpnconnect.com"
        #else
            static let root = "https://prod.sysvpnconnect.com"
        #endif
        
        struct Path {
            static let ipInfo = "/app/module_server/v1/app_setting/get_app_settings"
        }
    }
}
