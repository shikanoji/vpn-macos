//
//  IPCBaseConnection.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import Foundation
import os.log



/// App -> Provider IPC
@objc protocol ProviderCommunication {
    func getLogs( _ completionHandler: @escaping (Data?) -> Void)
    
    func request(request: URLRequest)
}

/// Provider -> App IPC
@objc protocol AppCommunication {
}
