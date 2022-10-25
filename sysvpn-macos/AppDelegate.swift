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
    
    //for  demo bit rate
    var statistics: NetworkStatistics?
    
    func applicationDidFinishLaunching(_: Notification) {
       
        
        // demo install extension vpn
       OSExtensionManager.shared.startExtension()
        DispatchQueue.main.async {
            DependencyContainer.shared.vpnManager.whenReady(queue: DispatchQueue.main) {
                print("readdy")
            }
        }
        onStartApp()
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
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        #if !targetEnvironment(simulator)
        NSApp.setActivationPolicy(.accessory)
        return false
        #else
        return true
        #endif
    }
    
    func onStartApp() {
        NotificationCenter.default.addObserver(self, selector: #selector(onStartJob), name: .startJobUpdateCountry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEndJob), name: .endJobUpdate, object: nil)
        timmerAppSetting?.invalidate()
        timmerAppSetting = Timer.scheduledTimer(timeInterval: 1000.0, target: self, selector: #selector(onReloadAppSetting), userInfo: nil, repeats: true)
    }
    
    @objc func onReloadAppSetting() {
        _ = APIServiceManager.shared.getAppSetting().subscribe { event in
             OpenWindows.LoginView.open()
             switch event {
             case let .success(response):
                 AppDataManager.shared.saveIpInfo(info: response.ipInfo)
                 AppDataManager.shared.userSetting = response
                 if AppDataManager.shared.lastChange != response.lastChange {
                     self.onReloadCountry()
                     self.onReloadMutilHop()
                 }
                 AppDataManager.shared.lastChange = response.lastChange ?? 0
             case let .failure(e):
                 guard let error = e as? ResponseError else {
                     return
                 }
                 print(error)
             }
         }
    }
    
    @objc func onStartJob(_ notification: Notification) {
        setupMenu()
        if let timmer = self.timmerJob {
          timmer.invalidate()
        }
        timmerJob = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(onLoadApiUpdateStar), userInfo: nil, repeats: true)
    }
    
    @objc func onEndJob(_ notification: Notification) {
        if let timmer = self.timmerJob {
          timmer.invalidate();
            timmerJob = nil
        }
        timmerJob = nil
        removeMenu()
    }
    
    @objc func onLoadApiUpdateStar() {
        
        if AppDataManager.shared.userCountry != nil { 
            _ = APIServiceManager.shared.getStartServer().subscribe({ result in
                switch result {
                case let .success(response):
                    response.updateStarCountry() 
                    NotificationCenter.default.post(name: .reloadServerStar, object: nil)
                case .failure(_):
                    break
                }
            })
        } 
    }
    
    func onReloadCountry() {
        _ = APIServiceManager.shared.getListCountry().subscribe({ result in
            switch result {
            case let .success(response):
                AppDataManager.shared.userCountry = response
                self.onLoadApiUpdateStar()
                NotificationCenter.default.post(name: .updateCountry, object: nil)
            case .failure(_):
                break
            }
        })
    }
    
    func onReloadMutilHop() {
        _ = APIServiceManager.shared.getListMultiHop().subscribe({ result in
            switch result {
            case let .success(response):
                AppDataManager.shared.mutilHopServer = response
            case .failure(_):
                break
            }
        })
    }
 
    
}
