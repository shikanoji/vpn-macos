//
//  MenuQuickAccessModel.swift
//  sysvpn-macos
//
//  Created by doragon on 30/09/2022.
//

import Cocoa
import Foundation
import SwiftUI

extension MenuQuickAccessView {
    @MainActor class MenuQuickAccessModel: ObservableObject {
        @Published var userIp: String = ""
        @Published var protected: String = ""
        @Published var location: String = ""
        @Published var tabIndex: Int
        @Published var downloadSpeed: String = ""
        @Published var uploadSpeed: String = ""
        @Published var tabbarSelectedItem: TabbarMenuItem = .recent
        //   @Published var listData: [TabbarListItemModel]
        @Published var listRecent: [TabbarListItemModel]
        @Published var listSuggest: [TabbarListItemModel]
        @Published var listCountry: [TabbarListItemModel]
    
        init() {
            userIp = "IP: \(AppDataManager.shared.userIp) -"
            location = AppDataManager.shared.isConnect ? L10n.Login.titleNotConnect : "Location: \(AppDataManager.shared.userCity)"
            tabIndex = 0
            downloadSpeed = "0 B/s"
            uploadSpeed = "0 B/s"
            //   listData = []
            listRecent = []
            listSuggest = []
            listCountry = []
            getListRecent()
            getListSuggest()
            getListCountry()
            // listData = listRecent
        }
        
        func onTouchConnect() {
            DependencyContainer.shared.vpnCore.quickConnect()
        }
        
        func onTouchDisconnect() {
            DependencyContainer.shared.vpnCore.disconnect()
        }
        
        func onQuit() {
            AppDataManager.shared.logOut {
                NSApp.terminate(nil)
            }
        }
        
        func onOpenApp() {
            _ = NSApp.setActivationPolicy(.regular)
            DispatchQueue.main.async {
                if let window = NSApp.mainWindow {
                    window.orderFrontRegardless()
                } else {
                    if let url = URL(string: "sysvpn://main") {
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
         
        func getListRecent() {
            let recentCountry = AppDataManager.shared.userCountry?.recentCountries ?? []
            for item in recentCountry {
                let itemModel = TabbarListItemModel(title: item.name ?? "", imageUrl: item.flag, lastUse: item.lastUse ?? Date())
                listRecent.append(itemModel)
            }
        }
        
        func getListSuggest() {
            let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
            for item in recommendCountry {
                let itemModel = TabbarListItemModel(title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag)
                listSuggest.append(itemModel)
            }
        }
        
        func getListCountry() {
            let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            for item in availableCountry {
                let itemModel = TabbarListItemModel(title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag)
                listCountry.append(itemModel)
            }
        }
    }
}
