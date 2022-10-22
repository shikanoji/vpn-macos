//
//  IPCNetworkExtension.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import os.log

class IPCNetworkExtension: XPCBaseService {
    lazy var urlConfiguration = {
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 10
        return urlconfig
    }()
    
    lazy var httpService = IPCHttpServiceService.init(session: URLSession(configuration: urlConfiguration))
    
    override func getLogs(_ completionHandler: @escaping (Data?) -> Void) {
        completionHandler("ok".data(using: .utf8))
    }
    
    override func request(request: [String: NSObject], completionHandler: @escaping ([String: NSObject]) -> Void) {
        guard let urlStr = request[HttpFieldName.url.rawValue] as? String, let url  = URL(string: urlStr) else {
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
         
        Task {
            do {
               // os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "start request")

                let response = try await httpService.performRequest(urlRequest: finalRequest)
                if let data = response {
                    completionHandler([
                        HttpFieldName.statusCode.rawValue: 200 as NSObject,
                        HttpFieldName.data.rawValue: data as NSObject
                    ])
                } else {
                    completionHandler([
                        HttpFieldName.statusCode.rawValue: 200 as NSObject
                    ])
                }
                os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default,"success")

            } catch let e {
                os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, e.localizedDescription)

                if let error = e as? NSError  {
                    completionHandler([
                        HttpFieldName.statusCode.rawValue: error.code as NSObject,
                        HttpFieldName.error.rawValue: error.domain as NSObject,
                    ])
                }
            } 
        }
    }
}

