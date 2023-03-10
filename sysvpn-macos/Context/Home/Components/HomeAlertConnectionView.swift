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
                Text(L10n.Global.unprotectedAlertTitle(appState.userIpAddress))
                    .font(.system(size: 12))
                Spacer().frame(height: 4)
                Text(L10n.Global.unprotectedAlertMessage)
                    .font(.system(size: 12))
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            }.foregroundColor(Color.white)
            Spacer()
        }.padding(20)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}
