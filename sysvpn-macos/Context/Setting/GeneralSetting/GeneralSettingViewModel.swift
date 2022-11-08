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
            let itemAutoLauch = SwitchSettingItem(settingName: L10n.Global.autoLaunch, settingDesc: L10n.Global.autoLaunchDesc, settingValue: false, itemType: .autoLaunch)
            let startMinimized = SwitchSettingItem(settingName: L10n.Global.startMinimized, settingDesc: L10n.Global.startMinimizedDesc, settingValue: false, itemType: .startMinimized)
            let systemNoti = SwitchSettingItem(settingName: L10n.Global.systemNoti, settingDesc: L10n.Global.systemNotiDesc, settingValue: false, itemType: .systemNoti)
            let appLanguage = SelectSettingItem<String>(settingName: L10n.Global.appLanguage, settingValue: "English", settingData: ["English", "Viet Nam", "123123"])
            listItem.append(itemAutoLauch)
            listItem.append(startMinimized)
            listItem.append(systemNoti)
            listItem.append(appLanguage)
        }
        
        func onChangeValue(value: Bool, item: SwitchSettingItem) {
            print("value: \(value) \(item.settingName)")
        }
        
        func onSelectValue(value: String, item: SettingElementType) {
            
        }
        
        func onLogOut() {
            AppDataManager.shared.accessToken = ""
            _ = APIServiceManager.shared.onLogout().subscribe { _ in
                
            }
            OpenWindows.LoginView.open()
        }
    }
}
