//
//  main.swift
//  TunnelKitHost
//
//  Created by macbook on 16/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import NetworkExtension
import os.log
import SwiftyBeaver

let ipc = IPCNetworkExtension(withExtension: "QPLVP53378.group.com.thuc.macos.TunnelKit.Demo.OpenVPN.Tunnel", logger: {
    if #available(macOS 12, *) {
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, $0)
    }
})

autoreleasepool {
    NEProvider.startSystemExtensionMode()
    ipc.startListener()
}

dispatchMain()
