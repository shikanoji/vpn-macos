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
    var timmerJob: Timer?
    var timmerAppSetting: Timer?

    // for  demo bit rate
    var statistics: NetworkStatistics?
    
    func applicationDidFinishLaunching(_: Notification) {
        // demo install extension vpn
        OSExtensionManager.shared.startExtension()
        onStartApp()
        initNotificationObs()
    }
    
    func setupMenu() {
        #if !targetEnvironment(simulator)
            NSApp.activate(ignoringOtherApps: false)
            if menuExtrasConfigurator == nil {
                menuExtrasConfigurator = .init()
            } else {
                menuExtrasConfigurator?.show()
            }
        #endif
    }
    
    func removeMenu() {
        menuExtrasConfigurator?.hide()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        if !AppDataManager.shared.isLogin {
            return true
        }
        #if !targetEnvironment(simulator)
            NSApp.setActivationPolicy(.accessory)
            return false
        #else
            return true
        #endif
    }
    
    func initNotificationObs() {
        NotificationCenter.default.addObserver(self, selector: #selector(onStartJob), name: .startJobUpdateCountry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEndJob), name: .endJobUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateServerInfo), name: .needUpdateServerInfo, object: nil)
    }
    
    func onStartApp() {
        timmerAppSetting?.invalidate()
        timmerAppSetting = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(onReloadAppSetting), userInfo: nil, repeats: true)
        DispatchQueue.main.async {
            // referesh now
            self.onReloadAppSetting()
        }
    }
   
    @objc func onStartJob(_: Notification) {
        setupMenu()
        if let timmer = timmerJob {
            timmer.invalidate()
        }
        timmerJob = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(onLoadApiUpdateStar), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            // referesh now
            self.onLoadApiUpdateStar()
        }
    }
    
    @objc func onEndJob(_: Notification) {
        if let timmer = timmerJob {
            timmer.invalidate()
            timmerJob = nil
        }
        timmerJob = nil
        removeMenu()
    }
    
    @objc func onReloadAppSetting() {
        AppDataManager.shared.loadAppSetting {
            print("[Debug] load app setting done")
        }
        AppDataManager.shared.updaterServerIP()
    }
    
    @objc func onLoadApiUpdateStar() {
        AppDataManager.shared.loadUpdateStast {
            print("[Debug] refresh server stast done")
        }
    }
    
    @objc func onUpdateServerInfo() {
        onReloadCountry()
        onReloadMutilHop()
    }
    
    func onReloadCountry() {
        AppDataManager.shared.loadCountry {
            print("[Debug] refresh country done")
        }
    }
    
    func onReloadMutilHop() {
        AppDataManager.shared.loadListMultiHop {
            print("[Debug] refresh multihop done")
        }
    }
}
