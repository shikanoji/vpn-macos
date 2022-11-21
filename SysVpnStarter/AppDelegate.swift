//
//  AppDelegate.swift
//  SysVPNStarter
//
//  Created by macbook on 18/11/2022.
//

import Cocoa
 
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let mainBundleIdentifier = bundleIdentifier.replacingOccurrences(of: #"-starter$"#, with: "", options: .regularExpression)
       
        // Ensures the app is not already running.
        guard NSRunningApplication.runningApplications(withBundleIdentifier: mainBundleIdentifier).isEmpty else {
            NSApp.terminate(nil)
            return
        }
        
        let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
        let mainPath = NSString.path(withComponents: Array(pathComponents[0...(pathComponents.count - 5)]))
        NSWorkspace.shared.launchApplication(mainPath)
        NSApp.terminate(nil)
    }
}
