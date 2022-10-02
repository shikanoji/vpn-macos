//
//  AppDelegate.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 30/08/2022.
//

import AppKit
import SwiftUI
 
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuExtrasConfigurator: MenuQuickAccessConfigurator?
    var appState = GlobalAppStates()
    
    func applicationDidFinishLaunching(_: Notification) {
        #if !targetEnvironment(simulator)
                NSApp.activate(ignoringOtherApps: false)
               
                menuExtrasConfigurator = .init()
        #endif
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        #if !targetEnvironment(simulator)
        NSApp.setActivationPolicy(.accessory)
        return false
        #else
        return true
        #endif
        
    }
    
 
    
}
