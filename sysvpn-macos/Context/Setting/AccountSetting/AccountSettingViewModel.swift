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
        @Published var isChangePasswordSuccess: Bool = false
        init() {
            listItem = []
            let emailUser = AppDataManager.shared.userData?.email ?? ""
            let emailAccount = EmailSettingItem(settingName: L10n.Global.emailAccount, settingDesc: L10n.Global.emailAccount, settingValue: emailUser)
            let subscriptionDetails = SubscriptionSettingItem(settingName: L10n.Global.subscriptionDetails, settingDesc: L10n.Global.startMinimizedDesc)
            let accountSercurity = ChangePasswordSettingItem(settingName: L10n.Global.accountSercurity, settingDesc: L10n.Global.systemNotiDesc)
            let newsletters = SwitchSettingItem(settingName: L10n.Global.newsletters, settingDesc: L10n.Global.newslettersDesc, settingValue: false, itemType: .newsletters)
            listItem.append(emailAccount)
            listItem.append(subscriptionDetails)
            listItem.append(accountSercurity)
            listItem.append(newsletters)
        }
        
        func onAccept() {
            isChangePasswordSuccess = true
        }
        
        func onChangeValue(value: Bool, item: SwitchSettingItem) {
            if item.itemType == .killSwitch {
                PropertiesManager.shared.killSwitch = value
            } else if item.itemType == .autoConnect {
                print("value autoConnect: \(value) \(item.settingName)")
            } else if item.itemType == .cyberSec {
                print("value cyberSec: \(value) \(item.settingName)")
            }
        }
        
        func onSelectValue(value: String, item: SettingElementType) {
            print("value: \(value):   item: \(item.settingName)")
        }
    }
}
