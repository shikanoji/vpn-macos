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
    var onHoverNode: ((Bool) -> Void)?
    var scaleView: CGFloat = 1.1
    @State private var iconImage: Image?

    var body: some View {
        return ZStack {
            iconImage?
                .resizable()
                .frame(width: 18 * scaleView, height: 18 * scaleView)
                .onHover { hover in
                    onHoverNode?(hover)
                }
            if locationIndex != nil {
                Text(String(locationIndex ?? 0))
                    .font(.system(size: 13))
                    .foregroundColor(Color.white)
                    .background(
                        Asset.Assets.icMapLocation.swiftUIImage
                            .resizable()
                            .frame(width: 30 * scaleView, height: 30 * scaleView, alignment: .center).transformEffect(CGAffineTransform(translationX: 0, y: 2))
                    ).transformEffect(CGAffineTransform(translationX: 0, y: -30 * scaleView))
            }
            
        }.onChange(of: state) { newValue in
            iconImage = newValue.icon
        }.onAppear {
            iconImage = state.icon
        }
    }
}
 
struct VpnMapPointView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapPointView(state: .activeDisabled, locationIndex: 1)
            .frame(width: 199, height: 199, alignment: .center)
    }
}
