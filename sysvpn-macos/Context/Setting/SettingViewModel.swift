//
//  SettingViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import Foundation
extension SettingView {
        @MainActor class SettingViewModel: ObservableObject {
            @Published var selectTabbarItem: TabbarSettingType = .general
            @Published var listItem : [TabbarSettingItem]
            
            init () {
                listItem = [TabbarSettingItem(type: .general), TabbarSettingItem(type: .vpnSetting), TabbarSettingItem(type: .account), TabbarSettingItem(type: .statistics), TabbarSettingItem(type: .appearence), TabbarSettingItem(type: .supportCenter)]
            }
        }
}
