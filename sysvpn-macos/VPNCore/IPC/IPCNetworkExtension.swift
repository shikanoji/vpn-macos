//
//  IPCNetworkExtension.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import os.log
import TunnelKitManager

class IPCNetworkExtension: XPCBaseService {
    let userDefaults = UserDefaults(suiteName: CoreAppConstants.AppGroups.main)

    lazy var urlConfiguration: URLSessionConfiguration = {
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 10
        return urlconfig
    }()
    
    lazy var httpService = IPCHttpServiceService(session: URLSession(configuration: urlConfiguration))
    
    override func setProtocol(vpnProtocol: String) {
        var isSuccess = false
    
        if vpnProtocol == "openVPN" {
            userDefaults?.set("openVPN", forKey: "vpnProtocol")
        } else {
            userDefaults?.set("wireGuard", forKey: "vpnProtocol")
        }
        isSuccess = userDefaults != nil
        
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "set protocol \(vpnProtocol) \(isSuccess ? "success" : "failed")")
    }
    
    override func getLogs(_ completionHandler: @escaping (Data?) -> Void) {
        completionHandler("ok".data(using: .utf8))
    }
    
    override func getProtocol(_ completion: @escaping (String) -> Void) {
        completion(userDefaults?.string(forKey: "vpnProtocol") ?? "openVPN")
    }
    
    override func request(request: [String: NSObject], completionHandler: @escaping ([String: NSObject]) -> Void) {
        guard let urlStr = request[HttpFieldName.url.rawValue] as? String, let url = URL(string: urlStr) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let method = request[HttpFieldName.method.rawValue] as? String {
            urlRequest.httpMethod = method
        }
        
        if let body = request[HttpFieldName.body.rawValue] as? Data {
            urlRequest.httpBody = body
        }
        
        if let headers = request[HttpFieldName.headers.rawValue] as? [String: String] {
            urlRequest.allHTTPHeaderFields = headers
        }
        let finalRequest = urlRequest
         
        httpService.performRequest(urlRequest: finalRequest) { response in
        
            completionHandler(response)
            os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "success")
        }
    }
}
