//
//  SettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text(L10n.Global.setting)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 18, weight: .semibold))
                }
                .padding(.vertical, 20)
                TabbarSettingView(selectedItem: $viewModel.selectTabbarItem, listItem: viewModel.listItem)
            }
            .contentShape(Rectangle())
            .background(Asset.Colors.headerSettingColor.swiftUIColor)
            ScrollView(.vertical, showsIndicators: false) {
                switch viewModel.selectTabbarItem {
                case .general:
                    GeneralSettingView()
                case .vpnSetting:
                    VpnSettingView()
                case .account:
                    AccountSettingView()
                case .statistics:
                    StatisticsSettingView()
                case .appearence:
                    AppearenceSettingView()
                case .supportCenter:
                    SupportCenterView()
                }
            }
            .background(Asset.Colors.bodySettingColor.swiftUIColor)
        }
        .cornerRadius(16)
        .frame(width: 600, height: 500, alignment: .center)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
