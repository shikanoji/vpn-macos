//
//  IpInfoModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/09/2022.
//

import Foundation
import SwiftyJSON

class AppSettingResponse : BaseModel{
    var lastChange: Int?
    var ipInfo: IpInfoModel?
    var appSettings: AppSettingModel?
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        lastChange = json[JSONIpInfoKey.lastChange].int
        ipInfo = IpInfoModel(json: json[JSONIpInfoKey.ipInfo])
        appSettings = AppSettingModel(json: json[JSONIpInfoKey.appSettings])
    }
}

class IpInfoModel: BaseModel { 
    var ip: String?
    var countryCode: String?
    var countryName: String?
    var city: String?
    var isp: String?
    var latitude: Double?
    var longitude: Double?
    var isProxy: Int?
    var proxyType: String?
    var proxyCountryCode: String?
    var proxyCountryName: String?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        ip = json[JSONIpInfoKey.ip].string
        isProxy = json[JSONIpInfoKey.isProxy].int
        countryCode = json[JSONIpInfoKey.countryCode].string
        countryName = json[JSONIpInfoKey.countryName].string
        city = json[JSONIpInfoKey.city].string
        isp = json[JSONIpInfoKey.isp].string
        proxyType = json[JSONIpInfoKey.proxyType].string
        proxyCountryCode = json[JSONIpInfoKey.proxyCountryCode].string
        proxyCountryName = json[JSONIpInfoKey.proxyCountryName].string
        latitude = json[JSONIpInfoKey.latitude].double
        longitude = json[JSONIpInfoKey.longitude].double
    } 
}

class AppSettingModel : BaseModel {
    var forceUpdateVersions: [Int]?
    var vpnSetting: VpnSettingModel?
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        forceUpdateVersions = json[JSONIpInfoKey.forceUpdateVersions].arrayValue.map({ data in
            return data.int ?? 0
        })
        vpnSetting = VpnSettingModel(json: json[JSONIpInfoKey.vpn])
    }
}

class VpnSettingModel : BaseModel{
    var defaultTech: String?
    var defaultProtocol: String?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        defaultTech = json[JSONIpInfoKey.defaultTech].string
        defaultProtocol = json[JSONIpInfoKey.defaultProtocol].string
    }
    
    
}


struct JSONIpInfoKey {
    static let lastChange = "lastChange"
    static let ip = "ip"
    static let countryCode = "countryCode"
    static let countryName = "countryName"
    static let city = "city"
    static let isp = "isp"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let isProxy = "isProxy"
    static let proxyType = "proxyType"
    static let proxyCountryCode = "proxyCountryCode"
    static let proxyCountryName = "proxyCountryName"
    static let ipInfo = "ipInfo"
    static let appSettings =  "appSettings"
    static let forceUpdateVersions =  "forceUpdateVersions"
    static let vpn =  "vpn"
    static let defaultTech =  "defaultTech"
    static let defaultProtocol =  "defaultProtocol"
}



