//
//  AccountSettingViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import Foundation

extension AccountSettingView {
    @MainActor class AccountSettingViewModel: ObservableObject {
        @Published var listItem: [SettingElementType]
        
        init() {
            listItem = []
            let emailAccount = SwitchSettingItem(settingName: L10n.Global.emailAccount, settingDesc: L10n.Global.emailAccount, settingValue: false)
            let subscriptionDetails = SwitchSettingItem(settingName: L10n.Global.subscriptionDetails, settingDesc: L10n.Global.startMinimizedDesc, settingValue: false)
            let accountSercurity = SwitchSettingItem(settingName: L10n.Global.accountSercurity, settingDesc: L10n.Global.systemNotiDesc, settingValue: false)
            let newsletters = SelectSettingItem<String>(settingName: L10n.Global.newsletters, settingValue: "English", settingData: ["English", "Viet Nam", "123123"])
            listItem.append(emailAccount)
            listItem.append(subscriptionDetails)
            listItem.append(accountSercurity)
            listItem.append(newsletters)
        }
    }
}
