//
//  HomeAlertConnectionView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI

struct HomeAlertConnectionView : View {
    var body: some View {
        HStack(spacing: 16) {
            Asset.Assets.icUnprotected.swiftUIImage
            VStack(alignment: .leading) {
                Text("Your IP: 199.199.199.8 - Unprotected")
                Text("Connect to VPN to online sercurity")
            }.foregroundColor(Color.white)
            Spacer()
        }.padding(20)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
        
    }
}
