//
//  AccountSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct AccountSettingView: View {
    @StateObject private var viewModel = AccountSettingViewModel()
    @State var isActive = true
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.listItem) { item in
                if let itemSwitch = item as? SwitchSettingItem {
                    SettingSwitchComponent(itemSwitch: itemSwitch, isActive: itemSwitch.settingValue, onChangeValue: viewModel.onChangeValue)
                } else if let itemPassword = item as? ChangePasswordSettingItem {
                    SettingPasswordComponent(data: itemPassword, isActive: isActive, isChangePasswordSuccess: $viewModel.isChangePasswordSuccess, onTapAccept: viewModel.onAccept)
                } else if let data = item as? SubscriptionSettingItem {
                    SettingSubscriptionComponent(data: data) {
                        print("123123")
                    }
                } else if let email = item as? EmailSettingItem {
                    SettingEmailComponent(data: email)
                }
                
                if item.settingName != viewModel.listItem.last?.settingName {
                    Divider()
                        .background(Asset.Colors.dividerColor.swiftUIColor)
                }
            }
            /*
             List(viewModel.listItem) { item in
                 if let itemSwitch = item as? SwitchSettingItem {
                     SettingPasswordComponent(title: itemSwitch.settingName, desc: itemSwitch.settingDesc, isActive: itemSwitch.settingValue)
                 } else if let itemSelect = item as? SelectSettingItem<String> {
                     SettingSelectViewComponent(selectItem: itemSelect, valueSelect: itemSelect.settingValue ?? "")
                 }
                 if item.settingName != viewModel.listItem.last?.settingName {
                     Divider()
                         .background(Asset.Colors.dividerColor.swiftUIColor)
                 }
             }
              */
        }
        .padding(.horizontal, 30)
        .frame(width: 600)
    }
}
 