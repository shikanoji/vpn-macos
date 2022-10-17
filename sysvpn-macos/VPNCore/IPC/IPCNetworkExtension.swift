//
//  IPCNetworkExtension.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

class IPCNetworkExtension: XPCBaseService {
    lazy var httpService = IPCHttpServiceService.init(session: URLSession.shared)
    
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
                
            } catch let e {
                let error = e as NSError 
                completionHandler([
                    HttpFieldName.statusCode.rawValue: error.code as NSObject,
                    HttpFieldName.error.rawValue: error.domain as NSObject,
                ])
                
            } 
        }
    }
}

