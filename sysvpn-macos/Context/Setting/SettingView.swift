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
        VStack {
            Group {
                HStack {
                    Text(L10n.Global.setting)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 18, weight: .medium))
                }
                TabbarSettingView(selectedItem: $viewModel.selectTabbarItem, listItem: viewModel.listItem)
            }
            .contentShape(Rectangle())
            .background(Asset.Colors.headerSettingColor.swiftUIColor)
            
        }
        .frame(width: 600, height: 500, alignment: .center)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
