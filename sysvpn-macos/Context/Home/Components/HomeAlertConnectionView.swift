//
//  HomeAlertConnectionView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI

struct HomeAlertConnectionView: View {
    @EnvironmentObject var appState: GlobalAppStates
    var body: some View {
        HStack(spacing: 16) {
            Asset.Assets.icUnprotected.swiftUIImage
            VStack(alignment: .leading) {
                Text("Your IP: \(appState.userIpAddress) - Unprotected")
                    .font(.system(size: 12))
                Spacer().frame(height: 4)
                Text("Connect to VPN to online sercurity")
                    .font(.system(size: 12))
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            }.foregroundColor(Color.white)
            Spacer()
        }.padding(20)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}
