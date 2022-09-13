//
//  VpnMapView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI

struct VpnMapView: View {
    var body: some View {
        GeometryReader { proxy in
            LoopMapView(size: proxy.size)
                .scaledToFit()
                .clipShape(Rectangle())
                .modifier(ZoomModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
        }
    }
}

struct LoopMapView: View {
    var size: CGSize
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            HStack(spacing: 0) {
                Asset.Assets.mapLayer1
                    .swiftUIImage.resizable()
                    .frame(width: size.width, height: size.height)
                Asset.Assets.mapLayer1
                    .swiftUIImage.resizable()
                    .frame(width: size.width, height: size.height)
                Asset.Assets.mapLayer1
                    .swiftUIImage.resizable()
                    .frame(width: size.width, height: size.height)
            }
        }.frame(width: size.width * 3, height: size.height, alignment: .center)
    }
}

struct VpnMapView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapView()
    }
}
