//
//  VpnMapView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI
struct VpnMapView: View {
    var numberImage = 1;
    var aspecRaito: CGFloat = 1024/588
    var connectPoints: [ConnectPoint] = [
        ConnectPoint(point1: CGPoint(x: 100, y: 100), point2: CGPoint(x: 400, y: 500)),
        
        ConnectPoint(point1: CGPoint(x: 100, y: 400), point2: CGPoint(x: 100, y: 0)),
        
        ConnectPoint(point1: CGPoint(x: 300, y: 300), point2: CGPoint(x: 30, y: 100))
    ]
    var nodeList: [NodePoint] = [
        NodePoint(point: CGPoint(x: 400, y: 500), info: NodeInfoTest(state: .activated )),
        NodePoint(point: CGPoint(x: 100, y: 100), info: NodeInfoTest(state: .activeDisabled)),
        NodePoint(point: CGPoint(x: 300, y: 200), info: NodeInfoTest(state: .activated))
    ]
     
    var body: some View {
        GeometryReader { proxy in
            LoopMapView(size: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height), loop: numberImage,
                        
                        connectPoints: connectPoints,
                        nodeList: nodeList
            )
            .scaledToFit()
            .clipShape(Rectangle())
            .modifier(ZoomModifier(contentSize: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height), screenSize: proxy.size, numberImage: numberImage))
        }
    }
}

struct LoopMapView: View {
    var size: CGSize
    var scale: CGFloat = 2;
    var loop: Int
    var connectPoints: [ConnectPoint]
    var nodeList: [NodePoint]
    
    var mapLayer1: some View {
        Asset.Assets.mapLayer1.swiftUIImage.resizable()
            .frame(width: size.width * scale, height: size.height * scale)
    }
    
    var pointLayer: some View {
        VpnMapPointLayerView(
            connectPoints: connectPoints, nodeList: nodeList,
            scaleVector: scale
        )
        .frame(width: size.width  * scale, height: size.height  * scale)
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            HStack(spacing: 0) {
                ForEach((0..<loop), id: \.self) {_ in
                    mapLayer1
                }
            }
            HStack(spacing: 0) {
                ForEach((0..<loop), id: \.self) {_ in
                    pointLayer
                }
            }
        }.frame(width: size.width * CGFloat(loop) * scale, height: size.height * scale, alignment: .center).scaleEffect(1/scale)
    }
}

struct VpnMapView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapView(connectPoints: [], nodeList: [])
    }
}
