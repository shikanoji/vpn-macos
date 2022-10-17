//
//  main.swift
//  WireGuardSysExtension
//
//  Created by macbook on 17/10/2022.
//

import Foundation
import NetworkExtension
import os.log

os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "Start up 2")

autoreleasepool {
    NEProvider.startSystemExtensionMode()
}

dispatchMain()
