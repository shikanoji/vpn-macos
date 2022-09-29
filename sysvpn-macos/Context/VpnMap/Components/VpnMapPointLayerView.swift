//
//  VpnMapPointLayerView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI

import SwiftUITooltip

struct VpnMapPointLayerView : View {
    var connectPoints: [ConnectPoint]
    var nodeList: [NodePoint]
    var scaleVector: CGFloat = 1
    
    let lineGradient = Gradient(colors: [
        Asset.Colors.secondary.swiftUIColor
        , Asset.Colors.primaryColor.swiftUIColor
    ])
    
    func scalePoint(_ point: CGPoint) -> CGPoint{
        return CGPoint(x: point.x * scaleVector, y: point.y * scaleVector)
    }
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Canvas {  context, size in
                connectPoints.forEach { point in
                    context.stroke(point.buildPath(scale: scaleVector), with: .linearGradient(lineGradient, startPoint: scalePoint(point.point1), endPoint: scalePoint(point.point2)))
                }
            }
            
            ForEach(0..<nodeList.count, id: \.self) { index in
                VpnMapPointView( state: nodeList[index].info.state ).frame(width: 18, height: 18, alignment: .center).position(x: scalePoint(nodeList[index].point).x, y: scalePoint(nodeList[index].point).y)
            }
        }
    }
}


struct VpnMapPointLayerView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapPointLayerView(connectPoints: [
            ConnectPoint(point1: CGPoint(x: 100, y: 100), point2: CGPoint(x: 400, y: 500))
        ], nodeList: [
            NodePoint(point: CGPoint(x: 400, y: 500), info: NodeInfoTest(state: .activated)),
            NodePoint(point: CGPoint(x: 100, y: 100), info: NodeInfoTest(state: .activeDisabled)),
            NodePoint(point: CGPoint(x: 900, y: 800), info: NodeInfoTest(state: .activated))
        ])
    }
}
