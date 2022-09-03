//
//  AppSetting.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 31/08/2022.
//

import Foundation

enum AppKeys: String {
    /// Auth Keys
    case sample
    case rememberLogin
}

class AppSetting {
    static var shared = AppSetting()
    
    init() {}
    
    var sample: String {
        get {
            return UserDefaults.standard.string(forKey: AppKeys.sample.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.sample.rawValue)
        }
    }
    
    var isRememberLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppKeys.rememberLogin.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: AppKeys.rememberLogin.rawValue)
        }
    }
}
