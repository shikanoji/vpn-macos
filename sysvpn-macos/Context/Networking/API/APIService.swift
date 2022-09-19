//
//  APIService.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 31/08/2022.
//

import Alamofire
import AppKit
import Moya

enum APIService {
    case getAppSettings
    case login(email: String, password: String)
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .getAppSettings, .login:
            return URL(string: Constant.API.root)!
        }
    }

    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getAppSettings:
            return Constant.API.Path.ipInfo
        case .login:
            return Constant.API.Path.login
        }
    }

    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getAppSettings:
            return .get
        case .login:
            return .post
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        var param: [String: Any] = [:]
        param["deviceInfo"] = ""
        switch self {
        case .getAppSettings:
            param["platform"] = "macos"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case let .login(email, password):
            param["email"] = email
            param["password"] = password
            /*
            let paramTest: [String: Any] = [
                "userIp": "127.0.0.1", "userCity": "Ha Noi", "userCountryCode": "VN", "deviceId": "device_id_1_2", "deviceCode": "device code", "deviceBrand": "SangML", "deviceApiVersion": "121", "deviceFingerprint": "123123123123123", "deviceOs": "Android", "deviceSupportedAbis": ["abc", "cde"], "deviceModel": "SangMList", "deviceIsRoot": 0, "deviceHardware": "Device hardware", "deviceManufacture": "Xiaomi", "deviceFreeMemory": 12312312, "osBuildNumber": "12", "osIncremental": "123123123", "osSecurityPath": "12", "appVersion": "1", "appBundleId": "com.ilg.sysvpn", "isEmulator": 0, "isTablet": 0
            ]
             */ 
            param["deviceInfo"] = AppSetting.shared.getDeviceInfo() // String(data: try! JSONSerialization.data(withJSONObject: paramTest, options: []), encoding: .utf8)
            
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }

    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/x-www-form-urlencoded"]
        }
    }
}
