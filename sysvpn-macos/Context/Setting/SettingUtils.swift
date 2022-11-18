//
//  SettingUtils.swift
//  sysvpn-macos
//
//  Created by macbook on 18/11/2022.
//

import Foundation
import Cocoa
import ServiceManagement

class SettingUtils {
    
    static let shared = SettingUtils()
    
    func restoreStartOnBootStatus() {
        let enabled = PropertiesManager.shared.autoLaunch
        self.setAutoLaunch(enable: enabled)
    }
    
    func setAutoLaunch(enable: Bool) {
        // auto start
           let launcherAppId = "com.syspvn.client.macos-starter"
         //  let runningApps = NSWorkspace.shared.runningApplications
         //  let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
           SMLoginItemSetEnabled(launcherAppId as CFString, enable)

          /* if isRunning {
               DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
           }*/
    }
}
