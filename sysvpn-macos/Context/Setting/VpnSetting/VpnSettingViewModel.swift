//
//  VpnSettingViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import Foundation

extension VpnSettingView {
    @MainActor class VpnSettingViewModel: ObservableObject {
        @Published var listItem: [SettingElementType]
        
        init() {
            listItem = []
            let listCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            let itemAutoConnect = SwitchSettingItem(settingName: L10n.Global.autoConnect, settingDesc: L10n.Global.autoConnectDesc, settingValue: false)
            let killSwitch = SwitchSettingItem(settingName: L10n.Global.killSwitch, settingDesc: L10n.Global.killSwitchDesc, settingValue: false)
            let cyberSec = SwitchSettingItem(settingName: L10n.Global.cyberSec, settingDesc: L10n.Global.cyberSecDesc, settingValue: false)
            let typeConnect = SelectSettingItem<String>(settingName: L10n.Global.protocol, settingValue: "OpenVPN (TCP)", settingData: ["OpenVPN (TCP)", "OpenVPN (UDP)", "123123"])
            let optionQuickConnect = SelectSettingItem<CountryAvailables>(settingName: L10n.Global.quickConnect, settingValue: listCountry.first, settingData: listCountry)
            listItem.append(itemAutoConnect)
            listItem.append(typeConnect)
            listItem.append(killSwitch)
            listItem.append(cyberSec)
        }
    }
}
