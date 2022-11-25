//
//  GeneralSettingViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import Foundation

extension GeneralSettingView {
    @MainActor class GeneralSettingViewModel: ObservableObject {
        @Published var listItem: [SettingElementType]
        
        init() {
            listItem = []
            let itemAutoLauch = SwitchSettingItem(settingName: L10n.Global.autoLaunch, settingDesc: L10n.Global.autoLaunchDesc, settingValue: PropertiesManager.shared.autoLaunch, itemType: .autoLaunch)
            let startMinimized = SwitchSettingItem(settingName: L10n.Global.startMinimized, settingDesc: L10n.Global.startMinimizedDesc, settingValue: PropertiesManager.shared.startMinimized, itemType: .startMinimized)
            let systemNoti = SwitchSettingItem(settingName: L10n.Global.systemNoti, settingDesc: L10n.Global.systemNotiDesc, settingValue: PropertiesManager.shared.systemNotification, itemType: .systemNoti)
            let appLanguage = SelectSettingItem<String>(settingName: L10n.Global.appLanguage, settingValue: "English", settingData: ["English"])
            listItem.append(itemAutoLauch)
            listItem.append(startMinimized)
            listItem.append(systemNoti)
            listItem.append(appLanguage)
        }
        
        func onChangeValue(value: Bool, item: SwitchSettingItem) {
            print("value: \(value) \(item.settingName)")
            switch item.itemType {
            case .autoLaunch:
                PropertiesManager.shared.autoLaunch = value
                SettingUtils.shared.setAutoLaunch(enable: value)
            case .startMinimized:
                PropertiesManager.shared.startMinimized = value
            case .systemNoti:
                PropertiesManager.shared.systemNotification = value
                if value {
                    AppAlertManager.shared.requestPermission()
                }
            default:
                break
            }
        }
        
        func onSelectValue(value: String, item: SettingElementType) {}
        
        func onLogOut() {
            AppDataManager.shared.logOut(openWindow: true)
        }
    }
}
