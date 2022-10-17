//
//  BaseIPCNetworkExtension.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

class IPCNetworkExtension: XPCBaseService {
    override func getLogs(_ completionHandler: @escaping (Data?) -> Void) {
        completionHandler("ok".data(using: .utf8))
    }
}

