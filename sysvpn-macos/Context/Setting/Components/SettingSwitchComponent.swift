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
    var onChangeValue: @MainActor (_ value: Bool, _ item: SwitchSettingItem) -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(itemSwitch.settingName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 14, weight: .semibold))
                    .padding(.bottom, 2)
                if itemSwitch.settingDesc != nil {
                    Text(itemSwitch.settingDesc!)
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                        .font(Font.system(size: 13, weight: .regular))
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

struct SettingEmailComponent: View {
    var data: EmailSettingItem
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.settingName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 14, weight: .semibold))
                    .padding(.bottom, 2)
                if data.settingDesc != nil {
                    Text(data.settingDesc!)
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                        .font(Font.system(size: 13, weight: .regular))
                }
            }
            Spacer()
            Text(data.settingValue)
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                .font(Font.system(size: 12, weight: .semibold))
                .padding(.bottom, 2)
        }
        .padding(.vertical, 15)
    }
}

struct SettingSubscriptionComponent: View {
    var data: SubscriptionSettingItem
    var onTapItem: @MainActor () -> Void
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.settingName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 14, weight: .semibold))
                    .padding(.bottom, 2)
                if data.settingDesc != nil {
                    HStack {
                        Text( data.isPremium ? "PREMIUM" : "FREE")
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                            .font(Font.system(size: 13, weight: .regular))
                            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Asset.Colors.subTextColor.swiftUIColor, lineWidth: 1.2)
                            )
                        if let date = data.premiumDateExpried {
                            Text("Exprire on \(formatDate(date: date))")
                                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                                .font(Font.system(size: 13, weight: .regular))
                        }
                        
                    }
                }
            }
            Spacer()
            Text("Manage subscription")
                .foregroundColor(Color.white)
                .font(Font.system(size: 13, weight: .semibold))
                .padding(.bottom, 2)
                .onTapGesture {
                    onTapItem()
                }
        }
        .padding(.vertical, 15)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
