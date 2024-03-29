//
//  VpnSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct VpnSettingView: View {
    @StateObject private var viewModel = VpnSettingViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.listItem) { item in
                if let itemSwitch = item as? SwitchSettingItem {
                    SettingSwitchComponent(itemSwitch: itemSwitch, isActive: itemSwitch.settingValue, onChangeValue: viewModel.onChangeValue)
                } else if let itemSelect = item as? SelectSettingItem<String> {
                    SettingSelectViewComponent(selectItem: itemSelect, valueSelect: itemSelect.settingValue ?? "", onChangeValue: viewModel.onSelectValue)
                } else if let itemCountry = item as? SelectSettingItem<CountryAvailables> {
                    SettingSearchViewComponent(selectItem: itemCountry, valueSelect: itemCountry.settingValue, onChangeValue: viewModel.onSelectValueCountry)
                }
                
                if item.settingName != viewModel.listItem.last?.settingName {
                    Divider()
                        .background(Asset.Colors.dividerColor.swiftUIColor)
                }
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
    }
}

struct VpnSettingView_Previews: PreviewProvider {
    static var previews: some View {
        VpnSettingView()
    }
}
