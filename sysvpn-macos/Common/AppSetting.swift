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
    case userIp
    case userCity
    case userCountryCode
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
    
    var deviceId: String {
        return hardwareUUID() ?? "doragon"
    }
    
    var deviceVersion: String {
        let info = ProcessInfo.processInfo.operatingSystemVersion
        return "MacOs \(info.majorVersion).\(info.minorVersion).\(info.patchVersion)"
    }
    
    var deviceOs: String {
        return "MacOs"
    }
    
    func hardwareUUID() -> String? {
        let matchingDict = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, matchingDict)
        defer { IOObjectRelease(platformExpert) }

        guard platformExpert != 0 else { return nil }
        return IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String
    }
    
    func getDeviceInfo()  -> String {
        let jsonObject : [String: Any] = [
            "userIp": AppDataManager.shared.userIp ,
            "userCity": AppDataManager.shared.userCity,
            "userCountryCode":AppDataManager.shared.userCountryCode,
            "deviceId":deviceId,
            "deviceOs":deviceOs,
            "osBuildNumber":deviceVersion,
            "deviceFreeMemory":System.memoryUsage().free 
        ]
        return String(data: try! JSONSerialization.data(withJSONObject: jsonObject, options: []), encoding: .utf8) ?? ""
    }
    
    
}
