//
//  SettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    
    var onClose: (() -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 60)
                    Spacer()
                    Text(L10n.Global.setting)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 16, weight: .semibold))
                    Spacer()
                    Button {
                        onClose?()
                    } label: {
                        Asset.Assets.icCloseWhite.swiftUIImage
                            .resizable()
                            .frame(width: 20, height: 20)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
                TabbarSettingView(selectedItem: $viewModel.selectTabbarItem, listItem: viewModel.listItem)
            }
            .contentShape(Rectangle())
            .background(Asset.Colors.headerSettingColor.swiftUIColor)
            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: 10)
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
        .frame(minWidth: 10, maxWidth: 600)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
