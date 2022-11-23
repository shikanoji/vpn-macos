//
//  TabbarSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

enum TabbarSettingType {
    case general
    case vpnSetting
    case account
    case statistics
    case appearence
    
    func toString() -> String {
        switch self {
        case .general:
            return L10n.Global.general
        case .vpnSetting:
            return L10n.Global.vpnSetting
        case .account:
            return L10n.Global.account
        case .statistics:
            return L10n.Global.statistics
        case .appearence:
            return L10n.Global.appearence 
        }
    }
}

struct TabbarSettingItem: Identifiable, Hashable {
    var id = UUID()
    var type: TabbarSettingType
}

struct TabbarSettingView: View {
    @Binding var selectedItem: TabbarSettingType
    
    var listItem: [TabbarSettingItem]
    
    var body: some View {
        bodyMenu
    }
    
    var bodyMenu: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(listItem) { item in
                Button {
                    if item.type == .appearence {
                        return
                    }
                    withAnimation {
                        selectedItem = item.type
                    }
                } label: {
                    TabBarButton(text: item.type.toString(), isSelected: .constant(selectedItem == item.type))
                        .background(selectedItem == item.type ? Asset.Assets.bgActiveSetting.swiftUIImage.resizable() : nil)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .center
        )
    }
}
 
