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
        @Published var listItem: [TabbarSettingItem]
            
        init() {
            listItem = [TabbarSettingItem(type: .general), TabbarSettingItem(type: .vpnSetting), TabbarSettingItem(type: .account), TabbarSettingItem(type: .statistics), TabbarSettingItem(type: .appearence), TabbarSettingItem(type: .supportCenter)]
        }
    }
}
 
class SettingElementType: Identifiable {
    var id: UUID = .init()
    var settingName: String = ""
    var settingDesc: String?
}

enum SwitchSettingItemType {
    case autoLaunch
    case startMinimized
    case systemNoti
    case autoConnect
    case killSwitch
    case cyberSec
    case newsletters
}

class SwitchSettingItem: SettingElementType {
    var settingValue: Bool = false
    var itemType: SwitchSettingItemType
    
    init(settingName: String, settingDesc: String?, settingValue: Bool, itemType: SwitchSettingItemType) { 
        self.settingValue = settingValue
        self.itemType = itemType
        super.init()
        self.settingDesc = settingDesc
        self.settingName = settingName
    }
}

class SelectSettingItem<T>: SettingElementType {
    var settingValue: T?
    var settingData: [T]?
    
    init(settingName: String, settingValue: T?, settingData: [T]) {
        self.settingValue = settingValue
        self.settingData = settingData
        super.init()
        self.settingName = settingName
    }
}
 
