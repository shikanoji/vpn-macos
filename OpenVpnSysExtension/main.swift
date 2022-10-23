//
//  main.swift
//  OpenVpnSysExtension
//
//  Created by macbook on 17/10/2022.
//

import Foundation
import NetworkExtension
import os.log
 
let ipc = IPCNetworkExtension(withExtension:  IPCHelper.extensionMachServiceName(from: Bundle.main), logger: {
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC-OP", category: "IPC"), type: .default, $0)
})
 
autoreleasepool {
    NEProvider.startSystemExtensionMode()
    ipc.startListener()
}

dispatchMain()
