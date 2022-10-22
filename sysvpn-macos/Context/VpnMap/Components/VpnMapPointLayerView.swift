//
//  VpnMapPointLayerView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip

struct VpnMapPointLayerView: View {
    var connectedNodeInfo: INodeInfo?
    var connectPoints: [ConnectPoint]
    var nodeList: [NodePoint] 
    var scaleVector: CGFloat = 1
    var onTouchPoint: ((NodePoint) -> Void)?
    var onHoverNode: ((NodePoint, Bool) -> Void)?
    let lineGradient = Gradient(colors: [
        Asset.Colors.secondary.swiftUIColor,
        Asset.Colors.primaryColor.swiftUIColor
    ])
    
    func scalePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scaleVector, y: point.y * scaleVector)
    }
    
    var normalState: VpnMapPontState {
        if GlobalAppStates.shared.displayState == .connected || GlobalAppStates.shared.displayState == .connecting {
            return .disabled
        }
        return .normal
    }
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Canvas { context, _ in
                connectPoints.forEach { point in
                    context.stroke(point.buildPath(scale: scaleVector), with: .linearGradient(lineGradient, startPoint: scalePoint(point.point1), endPoint: scalePoint(point.point2)), lineWidth: 2)
                }
            }
            
            
            ForEach(0..<nodeList.count, id: \.self) { index in
                VpnMapPointView(state: normalState,
                                locationIndex: nodeList[index].info.localtionIndex,
                                onHoverNode: { hover in
                    onHoverNode?(nodeList[index], hover)
                }
                ).position(x: scalePoint(nodeList[index].point).x, y: scalePoint(nodeList[index].point).y)
                    .onTapGesture {
                        onTouchPoint?(nodeList[index])
                        print("location: \( scalePoint(nodeList[index].point).x )")
                    }
                    
            }
            
            if normalState == .disabled, let connectedNodeInfo = connectedNodeInfo, let node = connectedNodeInfo.toNodePoint() {
                VpnMapPointView(state:  .activated,
                                locationIndex: node.info.localtionIndex,
                                onHoverNode: { hover in
                    onHoverNode?(node, hover)
                }
                ).position(x: scalePoint(node.point).x, y: scalePoint(node.point).y)
                    .onTapGesture { 
                        onTouchPoint?(node)
                }
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
