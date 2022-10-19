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
    
    
    //for  demo bit rate
    var statistics: NetworkStatistics?
    
    func applicationDidFinishLaunching(_: Notification) {
        #if !targetEnvironment(simulator)
                NSApp.activate(ignoringOtherApps: false)
                menuExtrasConfigurator = .init()
        #endif
        
        // demo install extension vpn
       OSExtensionManager.shared.startExtension()
        DispatchQueue.main.async {
            DependencyContainer.shared.vpnManager.whenReady(queue: DispatchQueue.main) {
                print("readdy")
            }
        }
        /*
        let dj = DependencyContainer.shared
        // demo connect vpn
        
        DispatchQueue.main.async {
            dj.vpnManager.whenReady(queue: DispatchQueue.main) {
                dj.vpnCore.quickConnect()
            }
        }
       
        // demo xpc vpn
        IPCFactory.makeIPCService(proto: .openVPN).getLogs { data in
            print("[VPN] ===  \(data)")
        }
        /// demo get bit rate
        statistics = NetworkStatistics(with: 1, and: { bitrate in
            let download = bitrate.rateString(for: bitrate.download)
            let upload = bitrate.rateString(for: bitrate.upload)
            print ("bitrate :\(download) \(upload)")
        })
         */
         
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
