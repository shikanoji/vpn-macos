//
//  IPCBaseConnection.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import os.log

class XPCHttpResponse: NSObject {
    init(statusCode: Int, data: Data?, error: NSError?) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
    }

    var statusCode: Int
    var data: Data?
    var error: NSError?
}

enum HttpFieldName: String {
    case statusCode
    case headers
    case data
    case body
    case error
    case method
    case url
}

struct MoyaIPCErrorDomain {
    static var requestCancel = "com.giaynhap.RequestCancel"
    static var unknownError = "com.giaynhap.Unknown"
    static var stautsError = "com.giaynhap.HttpStatusCodeError"
    static var invalidResponse = "com.giaynhap.InvalidResponse"
}
   
/// App -> Provider IPC
@objc protocol ProviderCommunication {
    func getLogs(_ completionHandler: @escaping (Data?) -> Void)
    func request(request: [String: NSObject], completionHandler: @escaping ([String: NSObject]) -> Void)
    func setProtocol(vpnProtocol: String)
    func getProtocol(_ completion: @escaping (String) -> Void)
}

/// Provider -> App IPC
@objc protocol AppCommunication {}
