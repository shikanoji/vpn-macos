//
//  VpnMapPointView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip



struct VpnMapPointView : View {
    var state: VpnMapPontState = VpnMapPontState.normal
    var body : some View {
        return ZStack {
            state.icon.resizable().frame(width: 18, height: 18, alignment: .center)
        }
    }
}


struct VpnMapPointView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapPointView()
    }
}


 
