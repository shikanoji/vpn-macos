//
//  HomeView.swift
//  sysvpn-macos
//
//  Created by doragon on 14/09/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        HStack(spacing: 0){
            HomeLeftPanelView()
            .frame(width: 300)
            .contentShape(Rectangle())
            VpnMapView()
                .overlay() {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(colors: [
                                        Asset.Colors.mainBackgroundColor.swiftUIColor,
                                        Asset.Colors.mainLinearEndColor.swiftUIColor
                                    ], startPoint: UnitPoint.top, endPoint: UnitPoint.bottom)
                                ).frame(height: 100)
                            Text(L10n.Global.locationMap)
                        }
                        Spacer()
                        Rectangle()
                            .fill(
                                LinearGradient(colors: [
                                    Asset.Colors.mainLinearEndColor.swiftUIColor,
                                    Asset.Colors.mainBackgroundColor.swiftUIColor
                                ], startPoint: UnitPoint.top, endPoint: UnitPoint.bottom)
                            ).frame(height: 100)
                    }
                    .allowsHitTesting(false)
                }
            .contentShape(Rectangle())
            .edgesIgnoringSafeArea([.top])
          
        }.frame(minWidth: 1000, minHeight: 700)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
