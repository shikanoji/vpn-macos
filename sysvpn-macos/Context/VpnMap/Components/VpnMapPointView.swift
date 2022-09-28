//
//  VpnMapPointView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip

enum VpnMapPontState {
    case normal
    case disabled
    case activated
    case activeDisabled
    
    var icon: Image {
        switch self {
        case .normal:
            return Asset.Assets.icNode.swiftUIImage
        case .activated:
            return Asset.Assets.icNodeActive.swiftUIImage
        case .disabled:
            return Asset.Assets.icNodeDisabled.swiftUIImage
        case .activeDisabled:
            return Asset.Assets.icNodeActiveDisabled.swiftUIImage
        }
    }
}

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


 
