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
    var onHoverNode: (( Bool) -> Void)?
    @State private var iconImage: Image?
    @State private var fadeOut = false
    var body: some View {
        return ZStack {
            iconImage?
                .resizable()
                .opacity(fadeOut ? 0 : 1)
                .frame(width: 40, height: 40)
                .onHover { hover in
                onHoverNode?(hover)
            }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
            
            if locationIndex != nil {
                Text(String(locationIndex ?? 0))
                    .font(.system(size: 22))
                    .foregroundColor(Color.white)
                    .background(
                        Asset.Assets.icMapLocation.swiftUIImage
                            .resizable()
                            .frame(width: 65, height: 65, alignment: .center).transformEffect(CGAffineTransform(translationX: 0, y: 5))
                    ).transformEffect(CGAffineTransform(translationX: 0, y: -65))
            }
            
        }.onChange(of: state) { newValue in
            withAnimation {
                self.fadeOut.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        iconImage = newValue.icon
                        self.fadeOut.toggle()
                    }
                }
            }
        }.onAppear() {
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
