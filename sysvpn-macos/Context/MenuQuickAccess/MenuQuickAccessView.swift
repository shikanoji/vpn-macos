//
//  MenuQuickAccessView.swift
//  sysvpn-macos
//
//  Created by doragon on 29/09/2022.
//

import SwiftUI
 
struct MenuQuickAccessView: View {
    @StateObject private var viewModel = MenuQuickAccessModel()
    var sizeIcon: CGFloat = 20
    
    var body: some View {
        VStack (alignment: .leading) {
            headerMenuConnected
            bodyMenu
            footerMenu
        }
        .frame( height: 580)
        .cornerRadius(8)
    }
    
    var headerMenuNotConnect: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.userIp)
                    .lineLimit(nil)
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                    .padding(.bottom, 1)
                Text(L10n.Login.unprotected)
                    .lineLimit(nil)
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Asset.Colors.textErrorColor.swiftUIColor)
                    .padding(.bottom, 1)
            }
            Text(viewModel.location)
                .lineLimit(nil)
                .font(Font.system(size: 14))
                .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
            Spacer().frame(height: 20)
            Button {
                viewModel.onTouchConnect()
            } label: {
                Text(L10n.Login.quickConnect)
                    .font(Font.system(size: 14, weight: .semibold))
            }.buttonStyle(LoginButtonCTAStyle())
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .padding(30)
        .background(Color(hexString: "101016"))
    }
    
    var headerMenuConnected: some View {
        VStack(alignment: .leading) {
            HStack {
                Asset.Assets.avatarTest.swiftUIImage
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack (alignment: .leading) {
                    HStack {
                        Text(viewModel.userIp)
                            .lineLimit(nil)
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                            .padding(.bottom, 1)
                        Text(L10n.Login.protected)
                            .lineLimit(nil)
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundColor(Asset.Colors.primaryColor.swiftUIColor)
                            .padding(.bottom, 1)
                    }
                    Text(viewModel.location)
                        .lineLimit(nil)
                        .font(Font.system(size: 14))
                        .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                }
            }
            Spacer().frame(height: 20)
            HStack {
                HStack {
                    
                    HStack {
                        Asset.Assets.icArrowUp.swiftUIImage
                            .frame(width: sizeIcon, height: sizeIcon)
                        Text("900kb/s")
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                    }
                    Spacer().frame(width: 16)
                    HStack {
                        Asset.Assets.icArrowDown.swiftUIImage
                            .frame(width: sizeIcon, height: sizeIcon)
                        Text("900kb/s")
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                    }
         
                }
                .frame(width: 210)
                .padding(EdgeInsets(top: 13.0, leading: 8.0, bottom: 13.0, trailing: 10.0))
                .background(Color(hexString: "FFFFFF").opacity(0.2))
                .cornerRadius(8)
                Button {
                    viewModel.onTouchConnect()
                } label: {
                    Text(L10n.Login.disconnect)
                        .font(Font.system(size: 14, weight: .semibold))
                }
                .frame(width: 120)
                .buttonStyle(LoginButtonCTAStyle(bgColor: Color(hexString: "FFFFFF")))
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .padding(30)
        .background(Color(hexString: "105175"))
    }
    
    
    var bodyMenu: some View {
        VStack  {
            HStack {
                Button {
                    viewModel.onChageTab(index: 0)
                } label: {
                    TabBarButton(text: L10n.Login.recent, isSelected: .constant(viewModel.tabIndex == 0))
                        .frame(width: 110)
                        .background(viewModel.tabIndex == 0 ? Asset.Assets.bgTabbar.swiftUIImage: nil)
                }
                .frame(width: 110)
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    viewModel.onChageTab(index: 1)
                } label: {
                    TabBarButton(text:  L10n.Login.suggest, isSelected: .constant(viewModel.tabIndex == 1))
                    .frame(width: 110)
                    .background(viewModel.tabIndex == 1 ? Asset.Assets.bgTabbar.swiftUIImage: nil)
                     
                }
                .frame(width: 110)
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    viewModel.onChageTab(index: 2)
                } label: {
                    TabBarButton(text:  L10n.Login.allCountry, isSelected: .constant(viewModel.tabIndex == 2))
                    .frame(width: 110)
                    .background(viewModel.tabIndex == 2 ? Asset.Assets.bgTabbar.swiftUIImage: nil)
                    
                }
                .frame(width: 110)
                .buttonStyle(PlainButtonStyle())
                 
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
    
    var footerMenu: some View {
        HStack {
            Button {
                viewModel.onQuit()
            } label: {
                HStack {
                    Asset.Assets.icOff.swiftUIImage
                        .frame(width: sizeIcon, height: sizeIcon)
                    Text(L10n.Login.titleQuit)
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundColor(Asset.Colors.mainTextColor.swiftUIColor)
                }
            }.buttonStyle(PlainButtonStyle())
            Spacer()
            Button {
                viewModel.onOpenApp()
            } label: {
                HStack {
                    Asset.Assets.icLogoApp.swiftUIImage
                        .frame(width: sizeIcon, height: sizeIcon)
                    Text("\(L10n.Login.titleOpen) SysVPN")
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundColor(Asset.Colors.primaryColor.swiftUIColor)
                }
            }.buttonStyle(PlainButtonStyle())
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .padding(EdgeInsets(top: 25, leading: 30, bottom: 25, trailing: 30))
        .background(Color(hexString: "101016").opacity(0.85))
    }
}


struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .font(Font.system(size: 14))
            .foregroundColor(isSelected ? Asset.Colors.primaryColor.swiftUIColor : Asset.Colors.mainTextColor.swiftUIColor)
            .frame(maxWidth: 100, minHeight: 52, alignment: .center)
    }
}

struct MenuQuickAccessView_Previews: PreviewProvider {
    static var previews: some View {
        MenuQuickAccessView()
    }
}
