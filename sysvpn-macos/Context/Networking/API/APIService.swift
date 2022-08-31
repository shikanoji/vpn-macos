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
}

extension APIService: TargetType {
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .getAppSettings:
            return URL(string: Constant.API.root)!
        }
    }

    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getAppSettings:
            return Constant.API.Path.ipInfo
        }
    }

    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getAppSettings:
            return .get
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    var task: Task {
        switch self {
        case .getAppSettings:
            var param: [String: Any] = [:]
            param["platform"] = "macos"
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }

    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
