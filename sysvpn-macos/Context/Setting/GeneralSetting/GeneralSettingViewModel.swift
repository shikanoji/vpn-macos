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
            let itemAutoLauch = SwitchSettingItem(settingName: L10n.Global.autoLaunch, settingDesc: L10n.Global.autoLaunchDesc, settingValue: false)
            let startMinimized = SwitchSettingItem(settingName: L10n.Global.startMinimized, settingDesc: L10n.Global.startMinimizedDesc, settingValue: false)
            let systemNoti = SwitchSettingItem(settingName: L10n.Global.systemNoti, settingDesc: L10n.Global.systemNotiDesc, settingValue: false)
            let appLanguage = SelectSettingItem<String>(settingName: L10n.Global.appLanguage, settingValue: "English", settingData: ["English", "Viet Nam", "123123"])
            listItem.append(itemAutoLauch)
            listItem.append(startMinimized)
            listItem.append(systemNoti)
            listItem.append(appLanguage)
        }
    }
}
