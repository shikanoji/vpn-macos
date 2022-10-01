//
//  MenuQuickAccessModel.swift
//  sysvpn-macos
//
//  Created by doragon on 30/09/2022.
//

import Foundation
import SwiftUI
import Cocoa

extension MenuQuickAccessView {
    @MainActor class MenuQuickAccessModel: ObservableObject {
       
        
        @Published var userIp: String = ""
        @Published var protected: String = ""
        @Published var location: String = ""
        @Published var tabIndex: Int
        @Published var downloadSpeed: String = ""
        @Published var uploadSpeed: String = ""
    
        init() { 
            userIp = "IP: \(AppDataManager.shared.userIp) -"
            location = AppDataManager.shared.isConnect ? L10n.Login.titleNotConnect : "Location: \(AppDataManager.shared.userCity)"
            tabIndex = 0
            downloadSpeed = "900kb/s"
            uploadSpeed = "1080kb/s"
        }
        
        func onTouchConnect() {
            withAnimation {
                GlobalAppStates.shared.isConnected = true
            }
        }
        
        func onTouchDisconnect() {
            withAnimation {
                GlobalAppStates.shared.isConnected = false
            }
        }
        
        func onQuit() {
            NSApp.terminate(nil)
        }
        
        func onOpenApp() {
            NSApp.setActivationPolicy(.regular)
            DispatchQueue.main.async {
                if let window = NSApp.mainWindow {
                    window.orderFrontRegardless()
                } else {
                    if let url = URL(string: "sysvpn://") {
                         NSWorkspace.shared.open(url)
                     }
                }
                
                MenuQuickAccessConfigurator.closePopover()
            }
        }
        
        func onChageTab(index: Int) {
            withAnimation {
                tabIndex = index
            }
        }
    }
}
