//
//  MenuQuickAccessModel.swift
//  sysvpn-macos
//
//  Created by doragon on 30/09/2022.
//

import Cocoa
import Foundation
import Kingfisher
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
            NotificationCenter.default.addObserver(self, selector: #selector(onUpdateServer), name: .updateCountry, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: .updateCountry, object: nil)
        }
        
        @objc func onUpdateServer() {
            getListSuggest()
            getListCountry()
        }
        
        func onTouchConnect() {
            DependencyContainer.shared.vpnCore.quickConnect()
        }
        
        func onTouchDisconnect() {
            DependencyContainer.shared.vpnCore.disconnect()
        }
        
        func onQuit() {
            AppDataManager.shared.logOut {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    NSApp.terminate(nil)
                }
            }
        }
        
        func onOpenApp() {
            _ = NSApp.setActivationPolicy(.regular)
            DispatchQueue.main.async {
                if let window = NSApp.mainWindow {
                    window.orderFrontRegardless()
                } else {
                    if let url = URL(string: "sysvpn:/main") {
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
            if GlobalAppStates.shared.recentList.isEmpty {
                AppDataManager.shared.readRecent()
            }
            listRecent = []
            let node = MapAppStates.shared.connectedNode
            let recentCountry = GlobalAppStates.shared.recentList
           
            for item in recentCountry {
                let isConnecting = item.node.locationName == node?.locationName && item.node.locationSubname == node?.locationSubname
                
                let itemModel = TabbarListItemModel(title: item.node.locationName, imageUrl: item.node.imageUrl, lastUse: item.logDate, isConnecting: isConnecting, isShowDate: true, raw: item.node, image: NodeFlagThumbView(image: item.node.imageUrl, image2: (item.node as? MultiHopResult)?.entry?.country?.flag))
                listRecent.insert(itemModel, at: 0)
            }
        }
        
        func getListSuggest() {
            listSuggest = []
            let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
            for item in recommendCountry {
                let itemModel = TabbarListItemModel(title: item.name ?? "", totalCity: item.city?.count ?? 0, image: NodeFlagThumbView(image: item.flag))
                listSuggest.append(itemModel)
            }
        }
        
        func getListCountry() {
            listCountry = []
            let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            for item in availableCountry {
                let itemModel = TabbarListItemModel(title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, raw: item, image: NodeFlagThumbView(image: item.flag))
                listCountry.append(itemModel)
            }
        }
        
        func connect(to info: INodeInfo? = nil) {
            MapAppStates.shared.connectedNode = nil
            let dj = DependencyContainer.shared
            if let city = info as? CountryCity {
                dj.vpnCore.connect(with: .init(connectType: .cityId(id: city.id ?? 0)))
            } else if let country = info as? CountryAvailables {
                dj.vpnCore.connect(with: .init(connectType: .countryId(id: country.id ?? 0)))
            } else if let staticServer = info as? CountryStaticServers {
                dj.vpnCore.connectTo(connectType: .serverId(id: staticServer.serverId ?? 0), params: nil)
            } else if let multiplehop = info as? MultiHopResult {
                dj.vpnCore.connect(with: .init(connectType: .serverId(id: multiplehop.entry?.serverId ?? 0), params: SysVPNConnectParams(isHop: true)))
                multiplehop.entry?.city?.country = multiplehop.entry?.country
                multiplehop.exit?.city?.country = multiplehop.exit?.country
                MapAppStates.shared.connectedNode = multiplehop
            }
        }
    }
}
