//
//  HomeView.swift
//  sysvpn-macos
//
//  Created by doragon on 14/09/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            LeftMenuView().frame(width: 300)
            MapView()
        }
        .frame(minWidth: 1400, minHeight: 800)
    }
}

struct LeftMenuView: View {
    var body: some View {
        VStack {
            Text("Quick Connect").padding(.top, 60)
            Asset.Assets.icPower.swiftUIImage.frame(width: 183, height: 183).padding(.top, 20)
            
            Text("Manual connection").padding(.top, 100)
            HStack(alignment: .center) {
                Asset.Assets.icLocation.swiftUIImage.frame(width: 32, height: 32)
                VStack(alignment: .leading) {
                    Text("Manual connection")
                    Text("168 locations available")
                }.padding(.leading, 24)
            }
            .padding(EdgeInsets(top: 32, leading: 0, bottom: 16, trailing: 0))
            HStack {
                Asset.Assets.icIpAddress.swiftUIImage.frame(width: 32, height: 32)
                VStack(alignment: .leading) {
                    Text("Static IP")
                    Text("168 locations available")
                }.padding(.leading, 24)
            }.padding(.bottom, 16)
            HStack(alignment: .top) {
                Asset.Assets.icLink.swiftUIImage.frame(width: 32, height: 32)
                VStack(alignment: .leading) {
                    Text("MultiHop")
                    Text("168 locations available")
                }.padding(.leading, 24)
            }.padding(.bottom, 16)
            
            Text("Sysvpn Configuration")
            HStack {
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSetting.swiftUIImage
                            .frame(width: 32, height: 32)
                        Text("Setting")
                    }
                }
                .buttonStyle(ActionButtonStyle())
                
                Button {
                    print("Edit button was tapped")
                } label: {
                    HStack {
                        Asset.Assets.icSend.swiftUIImage
                            .frame(width: 32, height: 32)
                        Text("Help center")
                    }
                }
                .buttonStyle(ActionButtonStyle())
            }
            .padding([.leading, .trailing], 20)
            Divider().padding([.leading, .trailing], 20)
            HStack {
                Asset.Assets.avatarTest.swiftUIImage
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding([.leading, .top], 20)
                VStack(alignment: .leading) {
                    Text("Jason Vincius")
                    Text("312 days left")
                }.padding(EdgeInsets(top: 20, leading: 12, bottom: 0, trailing: 0))
                Spacer()
            }
        }
    }
}

struct MapView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
