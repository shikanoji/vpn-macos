//
//  VpnMapPointView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip

struct VpnMapPointView: View {
    var state: VpnMapPontState = .normal
    var locationIndex: Int?
    var body: some View {
        return ZStack {
            state.icon 
            if locationIndex != nil {
                Text(String(locationIndex ?? 0))
                    .foregroundColor(Color.white)
                    .background(
                        Asset.Assets.icMapLocation.swiftUIImage.frame(width: 80, height: 80, alignment: .center).transformEffect(CGAffineTransform(translationX: 0, y: 2))
                    ).transformEffect(CGAffineTransform(translationX: 0, y: -40))
            }
        }
    }
}
 
struct VpnMapPointView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapPointView()
    }
}
