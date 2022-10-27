//
//  HomeLeftPanelView.swift
//  sysvpn-macos
//
//  Created by doragon on 14/09/2022.
//

import Foundation
import SwiftUI
enum HomeMenuItem {
    case manualConnection
    case staticIp
    case multiHop
    case none
}

struct HomeLeftPanelView: View {
    @Binding var selectedItem: HomeMenuItem
    @StateObject private var viewModel = HomeLeftPanelViewModel()
     
    var iconSize: CGFloat = 32
    var quickConnectButton: some View {
        VStack {
            HomeConnectionButtonView {
                viewModel.onTapConnect()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
    
    var menuSection: some View {
        VStack(alignment: .leading) {
            Text(L10n.Global.manualConnection)
                .padding(.leading, 16)
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            HomeMenuButtonView(
                active: selectedItem == .manualConnection,
                icon: Asset.Assets.icLocation.swiftUIImage,
                title: L10n.Global.manualConnection,
                content: "\(viewModel.totalCountry) \(L10n.Global.manualCDesc)"
            ).onTapGesture {
                withAnimation {
                    selectedItem = .manualConnection
                }
            }
            HomeMenuButtonView(
                active: selectedItem == .staticIp,
                icon: Asset.Assets.icIpAddress.swiftUIImage,
                title: L10n.Global.staticIP,
                content: L10n.Global.staticIPDesc
            ).onTapGesture {
                withAnimation {
                    selectedItem = .staticIp
                }
            }
            HomeMenuButtonView(
                active: selectedItem == .multiHop,
                icon: Asset.Assets.icLink.swiftUIImage,
                title: L10n.Global.multiHop,
                content: L10n.Global.multiHopDesc
            ).onTapGesture {
                withAnimation {
                    selectedItem = .multiHop
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var settingSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSetting.swiftUIImage
                            .frame(width: 12, height: 12)
                        Text(L10n.Global.setting)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 12)
                }
                .buttonStyle(LoginButtonNoBackgroundStyle())
                
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSend.swiftUIImage
                            .frame(width: 12, height: 12)
                        Text(L10n.Global.helpCenter)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 12)
                }
                .buttonStyle(LoginButtonNoBackgroundStyle())
            }
            
        }.padding(.horizontal, 16)
    }
    
    var footerSection: some View {
        HStack {
            Asset.Assets.avatarTest.swiftUIImage
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text("Jason Vincius")
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.white)
                Spacer().frame(height: 8)
                HStack {
                    Text("312 days left")
                        .font(Font.system(size: 12, weight: .medium))
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    Text("+Extended")
                        .font(Font.system(size: 12, weight: .medium))
                        .foregroundColor(Color.white)
                }
            }
        }.padding(.horizontal, 16)
    }
    
    var itemSpacer: some View {
        Spacer().frame(height: 24)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            itemSpacer
            quickConnectButton
            menuSection
            Spacer(minLength: 24)
            footerSection
            itemSpacer
            Divider()
                .background(Color(rgb: 0x272936))
                .padding([.leading, .trailing], 16)
            itemSpacer
            settingSection
            itemSpacer
        }.background {
            ZStack {
                Rectangle().foregroundColor(Asset.Colors.backgroundColor.swiftUIColor)
                Rectangle()
                    .fill(
                        LinearGradient(colors: [
                            Asset.Colors.mainLinearStartColor.swiftUIColor,
                            Asset.Colors.mainLinearEndColor.swiftUIColor
                        ], startPoint: UnitPoint.top, endPoint: UnitPoint(x: 0.5, y: 0.3))
                    )
                    .edgesIgnoringSafeArea([.top])
            }
        }
    }
}

struct HomeLeftPanelView_Previews: PreviewProvider {
    @State static var selectedItem: HomeMenuItem = .none
    
    static var previews: some View {
        HomeLeftPanelView(selectedItem: $selectedItem)
            .frame(width: 240, height: 700.0)
            .environmentObject(GlobalAppStates.shared)
    }
}
 