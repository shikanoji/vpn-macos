//
//  SettingSwitchComponent.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import SwiftUI

struct SettingSwitchComponent: View { 
    var itemSwitch: SwitchSettingItem
    @State var isActive = true
    var onChangeValue : ( _ value :Bool, _ item : SwitchSettingItem) -> ()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(itemSwitch.settingName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                    .padding(.bottom, 2)
                if itemSwitch.settingDesc != nil {
                    Text(itemSwitch.settingDesc!)
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                        .font(Font.system(size: 14, weight: .regular))
                }
            }
            Spacer()
            Toggle("", isOn: $isActive)
                .toggleStyle(SwitchToggleStyle(tint: Asset.Colors.primaryColor.swiftUIColor))
                .onChange(of: isActive) { newValue in
                    print("change")
                    onChangeValue(newValue, itemSwitch)
                }
        }
        .padding(.vertical, 15)
    }
}
