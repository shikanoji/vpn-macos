//
//  GeneralSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct GeneralSettingView: View {
    @StateObject private var viewModel = GeneralSettingViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.listItem) { item in
                if let itemSwitch = item as? SwitchSettingItem {
                    SettingSwitchComponent(title: itemSwitch.settingName, desc: itemSwitch.settingDesc, isActive: itemSwitch.settingValue)
                } else if let itemSelect = item as? SelectSettingItem<String> {
                    SettingSelectViewComponent(selectItem: itemSelect, valueSelect: itemSelect.settingValue ?? "")
                }
                if item.settingName != viewModel.listItem.last?.settingName {
                    Divider()
                        .background(Asset.Colors.dividerColor.swiftUIColor)
                }
            }
            Button {
                //
            } label: {
                Text(L10n.Global.changePassword)
                    .foregroundColor(Color.white)
            }.buttonStyle(LoginButtonCTAStyle(bgColor: Asset.Colors.popoverBgSelected.swiftUIColor))
        }
        .padding(.horizontal, 30)
        .frame(width: 600)
    }
}

struct GeneralSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingView()
    }
}
