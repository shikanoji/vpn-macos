//
//  AppDataManager.swift
//  sysvpn-macos
//
//  Created by doragon on 18/09/2022.
//

import Foundation

extension String {
    static var keySaveRefreshToken = "USER_REFRESH_TOKEN_TEST_2"
    static var keySaveAccessToken = "USER_ACCESS_TOKEN_TEST_2   "
    static var keyUserIP = "USER_IP"
    static var keyUserCity = "USER_CITY"
    static var keyUserCountryCode = "USER_COUNTRY_CODE"
    static var keyUserLatitude = "USER_LATITUDE"
    static var keyUserLongitude = "USER_LONGTITUDE"
    static var keyUserIsp = "USER_ISP"
    static var keyUserIsConnect = "USER_IS_CONNECT"
    static var keyUserInfo = "KEY_USER_INFO"
    static var keySaveUserData = "KEY_USER_DATA"
    static var keySaveCountry = "KEY_SAVE_COUNTRY"
    static var keySaveUserSetting = "KEY_SAVE_USER_SETTING"
    static var keySaveLastChange = "KEY_SAVE_LAST_CHANGE"
    static var keySaveMutilHop = "KEY_SAVE_MULTI_HOP"
    static var keyIsMultiplehop = "KEY_IS_MULTI_HOP"
}

class AppDataManager {
    static var shared = AppDataManager()
    
    private var _user: AuthUser?
    
    var userData: AuthUser? {
        get {
            if !isLogin {
                return nil
            }
            if _user == nil {
                _user = AuthUser.fromSaved()
            }
            return _user
        }
        set {
            _user = newValue
            _user?.save()
        }
    }
    
    private var _cacheAccessToken: String?
    var accessToken: String? {
        get {
            if _cacheAccessToken == nil {
                _cacheAccessToken = UserDefaults.standard.string(forKey: .keySaveAccessToken)
            }
            return _cacheAccessToken
        }
        set {
            _cacheAccessToken = newValue
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: .keySaveAccessToken)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: .keySaveAccessToken)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    private var _cacheRefreshToken: String?
    var refreshToken: String? {
        get {
            if _cacheRefreshToken == nil {
                _cacheRefreshToken = UserDefaults.standard.string(forKey: .keySaveRefreshToken)
            }
            return _cacheRefreshToken
        }
        set {
            _cacheRefreshToken = newValue
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: .keySaveRefreshToken)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: .keySaveRefreshToken)
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
    
    var latitude: Double {
        get {
            return UserDefaults.standard.double(forKey: .keyUserLatitude)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserLatitude)
        }
    }
    
    var longitude: Double {
        get {
            return UserDefaults.standard.double(forKey: .keyUserLongitude)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserLongitude)
        }
    }
    
    var userIsp: String {
        get {
            return UserDefaults.standard.string(forKey: .keyUserIsp) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserIsp)
        }
    }
    
    var isConnect: Bool {
        get {
            return UserDefaults.standard.bool(forKey: .keyUserIsConnect)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keyUserIsConnect)
        }
    }
    
    var isMultipleHop: Bool {
        get {
           // return UserDefaults.standard.bool(forKey: .keyIsMultiplehop)
           return DependencyContainer.shared.vpnCore.lastConnectionConiguration?.connectionParam?.isHop == true
        }
       
    }
    
    func saveIpInfo(info: AppSettingIpInfo?) {
        userIp = info?.ip ?? "127.0.0.1"
        userCity = info?.city ?? "Ha Noi"
        userCountryCode = info?.countryCode ?? "VN"
        latitude = info?.latitude ?? 0.0
        longitude = info?.longitude ?? 0.0
        userIsp = info?.isp ?? ""
    }
    
    private var _userEtting: AppSettingResult?
    
    var userSetting: AppSettingResult? {
        get {
            if _userEtting == nil {
                _userEtting = AppSettingResult.getUserSetting()
            }
            return _userEtting
        }
        set {
            _userEtting = newValue
            _userEtting?.saveUserSetting()
        }
    }
    
    var lastChange: Double {
        get {
            return UserDefaults.standard.double(forKey: .keySaveLastChange)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: .keySaveLastChange)
        }
    }
    
    private var _userCountry: CountryResult?
    
    var userCountry: CountryResult? {
        get {
            if _userCountry == nil {
                _userCountry = CountryResult.getListCountry()
            }
            return _userCountry
        }
        set {
            _userCountry = newValue
            _userCountry?.saveListCountry()
        }
    }
    
    private var _recentCountries: [CountryAvailables]?
    
    func addRecentCountry(country: CountryAvailables) {
        if (_recentCountries?.count ?? 0) >= 5 {
            while (_recentCountries?.count ?? 0) >= 5 {
                _recentCountries?.removeLast()
            }
            _recentCountries?.append(country)
        } else {
            _recentCountries?.append(country)
        }
        _userCountry?.recentCountries = _recentCountries
        _userCountry?.saveListCountry()
    }
    
    private var _mutilHopServer: [MultiHopResult]?
    
    var mutilHopServer: [MultiHopResult]? {
        get {
            if _mutilHopServer == nil {
                _mutilHopServer = MultiHopSaveWraper.getListMultiHop()?.hop
            }
            return _mutilHopServer
        }
        set {
            _mutilHopServer = newValue
            let value = MultiHopSaveWraper(hop: newValue)
            value.saveListMultiHop()
        }
    }
    
    func getStaticNodeByServerInfo(server: VPNServer) -> INodeInfo? {
        if let node = userCountry?.staticServers?.first(where: { sInfo in
            return sInfo.serverId == server.id
        }) {
            return node
        }
        
        return nil
    }

    func getNodeByServerInfo(server: VPNServer) -> INodeInfo? {
        if isMultipleHop {
            guard let hop = mutilHopServer?.first(where: { sv in
                return sv.entry?.serverId == server.id
            }) else {
                return nil
            }
            hop.entry?.city?.country = hop.entry?.country
            hop.exit?.city?.country = hop.exit?.country
            return hop
        }
        guard let country = userCountry?.availableCountries?.first(where: { ct in
            return ct.city?.contains(where: { city in
                return city.id == server.cityId
            }) ?? false
        }) else {
            return getStaticNodeByServerInfo(server: server)
        }
        
        guard let city = country.city?.first(where: { city in
            return city.id == server.cityId
        }) else {
            return country
        }
        var updateCity = city
        updateCity.country = country
        
        return updateCity
    }
}
