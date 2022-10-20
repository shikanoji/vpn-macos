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
        #if !targetEnvironment(simulator)
                NSApp.activate(ignoringOtherApps: false)
                menuExtrasConfigurator = .init()
        #endif
        
        // demo install extension vpn
       OSExtensionManager.shared.startExtension()
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
        onStartApp()
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
        NotificationCenter.default.addObserver(self, selector: #selector(onStartJob), name: .endJobUpdate, object: nil)
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
    }
    
    @objc func onLoadApiUpdateStar() {
        if AppDataManager.shared.userCountry != nil { 
            _ = APIServiceManager.shared.getStartServer().subscribe({ result in
                switch result {
                case let .success(response):
                    response.updateStarCountry() 
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
    
 
    
}
