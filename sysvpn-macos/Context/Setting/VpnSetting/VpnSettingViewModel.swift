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
            let defaulProto = PropertiesManager.shared.vpnProtocol == .wireGuard ? "WireGuard" : (PropertiesManager.shared.vpnProtocol == .openVpn(.tcp) ? "OpenVPN (TCP)" : "OpenVPN (UDP)")
            let listCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            let itemAutoConnect = SwitchSettingItem(settingName: L10n.Global.autoConnect, settingDesc: L10n.Global.autoConnectDesc, settingValue: PropertiesManager.shared.getAutoConnect(for: AppDataManager.shared.userData?.email ?? "default").enabled, itemType: .autoConnect)
            let killSwitch = SwitchSettingItem(settingName: L10n.Global.killSwitch, settingDesc: L10n.Global.killSwitchDesc, settingValue: PropertiesManager.shared.killSwitch, itemType: .killSwitch)
            let cyberSec = SwitchSettingItem(settingName: L10n.Global.cyberSec, settingDesc: L10n.Global.cyberSecDesc, settingValue: PropertiesManager.shared.cybersec, itemType: .cyberSec)
            let typeConnect = SelectSettingItem<String>(settingName: L10n.Global.protocol, settingValue: defaulProto, settingData: ["OpenVPN (TCP)", "OpenVPN (UDP)", "WireGuard"])
            let optionQuickConnect = SelectSettingItem<CountryAvailables>(settingName: L10n.Global.quickConnect, settingValue: listCountry.first, settingData: listCountry)
            print(optionQuickConnect)
            listItem.append(itemAutoConnect)
            listItem.append(typeConnect)
            listItem.append(killSwitch)
            listItem.append(cyberSec)
        }
        
        func onChangeValue(value: Bool, item: SwitchSettingItem) {
            if item.itemType == .killSwitch {
                PropertiesManager.shared.killSwitch = value
            } else if item.itemType == .autoConnect {
                print("value autoConnect: \(value) \(item.settingName)")
                PropertiesManager.shared.setAutoConnect(for: AppDataManager.shared.userData?.email ?? "default", enabled: value, profileId: "0")
            } else if item.itemType == .cyberSec {
                print("value cyberSec: \(value) \(item.settingName)")
                PropertiesManager.shared.cybersec = value
            }
        }
        
        func onSelectValue(value: String, item: SettingElementType) {
            if item.settingName == L10n.Global.protocol {
                if value.contains("OpenVPN (TCP)") {
                    print("value: TCP")
                    PropertiesManager.shared.vpnProtocol = .openVpn(.tcp)
                } else if value.contains("OpenVPN (UDP)") {
                    print("value: UDP")
                    PropertiesManager.shared.vpnProtocol = .openVpn(.udp)
                } else {
                    PropertiesManager.shared.vpnProtocol = .wireGuard
                }
            }
        }
    }
}
