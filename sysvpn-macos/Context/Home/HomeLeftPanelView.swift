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
        .padding(.horizontal,30)
        
    }
    
    var menuSection : some View {
        
        VStack (alignment: .leading){
            Text("Manual connection").padding(.leading, 32)
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            HomeMenuButtonView(
                active: selectedItem == .manualConnection,
                icon: Asset.Assets.icLocation.swiftUIImage,
                title: "Manual connection",
                content: "\(viewModel.totalCountry) locations available"
            ).onTapGesture {
                withAnimation {
                    selectedItem = .manualConnection 
                }
            }
            HomeMenuButtonView(
                active: selectedItem == .staticIp,
                icon: Asset.Assets.icIpAddress.swiftUIImage,
                title: "Static IP",
                content: "Personal Static IP address"
            ) .onTapGesture {
                withAnimation {
                    selectedItem = .staticIp
                }
            }
            HomeMenuButtonView(
                active: selectedItem == .multiHop,
                icon: Asset.Assets.icLink .swiftUIImage,
                title: "MultiHop",
                content: "168 locations available"
            ).onTapGesture {
                withAnimation {
                    selectedItem = .multiHop
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    var settingSection : some View {
        VStack (alignment: .leading) {
            
            Text("Sysvpn Configuration")
                .font(Font.system(size: 14, weight: .regular))
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            Spacer().frame(height: 28)
            HStack {
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSetting.swiftUIImage
                            .frame(width: 16, height: 16)
                        Text("Setting")
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                }
                .buttonStyle(ActionButtonStyle())
                
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSend.swiftUIImage
                            .frame(width: 16, height: 16)
                        Text("Help center")
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                }
                .buttonStyle(ActionButtonStyle())
            }
            
        }.padding(.leading, 30)
    }
    
    var footerSection: some View {
        HStack {
              Asset.Assets.avatarTest.swiftUIImage
                .resizable()
                  .frame(width: 50, height: 50)
                  .cornerRadius(25)
              VStack(alignment: .leading) {
                  Text("Jason Vincius")
                      .font(Font.system(size: 16, weight: .bold))
                      .foregroundColor(Color.white)
                  Spacer().frame(height: 4)
                  Text("312 days left")
                      .font(Font.system(size: 14, weight: .medium))
                      .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
              }
        }.padding(24)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Spacer(minLength: 20)
            quickConnectButton
            Spacer(minLength: 20)
            menuSection
            Spacer(minLength: 20)
            settingSection
            Spacer().frame(height: 20)
            Divider().padding([.leading, .trailing], 20)
            Spacer()
          //  footerSection
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
    }
}
 
