//
//  AppDataManager.swift
//  sysvpn-macos
//
//  Created by doragon on 18/09/2022.
//

import Foundation

extension String {
    static var keySaveRefreshToken = "USER_REFRESH_TOKEN"
    static var keySaveAccessToken = "USER_ACCESS_TOKEN"
    static var keyUserIP = "USER_IP"
    static var keyUserCity = "USER_CITY"
    static var keyUserCountryCode = "USER_COUNTRY_CODE"
}

class AppDataManager {
    static var shared = AppDataManager()
    
    private var _user: UserModel?
    
    var userData: UserModel? {
        get {
            if !isLogin {
                return nil
            }
            if _user == nil {
                _user = UserModel.fromSaved()
            }
            return _user
        }
        set {
            _user = newValue
            _user?.save()
        }
    }
    
    private var _cacheToken: String?
    var accessToken: String? {
        get {
            if _cacheToken == nil {
                _cacheToken = UserDefaults.standard.string(forKey: .keySaveAccessToken)
            }
            return _cacheToken
        }
        set {
            _cacheToken = newValue
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: .keySaveAccessToken)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: .keySaveAccessToken)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    var isLogin: Bool {
        return (accessToken?.count ?? 0) > 0
    }
    
    var userIp: String {
        get {
            return UserDefaults.standard.string(forKey: .keyUserIP) ?? "127.0.0.1"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserIP)
        }
    }
    
    var userCity: String {
        get {
            return UserDefaults.standard.string(forKey: .keyUserCity) ?? "Ha Noi"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserCity)
        }
    }
    
    var userCountryCode: String {
        get {
            return UserDefaults.standard.string(forKey: .keyUserCountryCode) ?? "VN"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserCountryCode)
        }
    }
}
