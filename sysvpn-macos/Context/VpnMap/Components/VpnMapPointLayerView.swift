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
    var isShowCity: Bool = false
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
            ForEach(0..<nodeList.count, id: \.self) { index in
                VpnMapPointView(state: normalState,
                                locationIndex: nodeList[index].info.localtionIndex,
                                onHoverNode: { hover in
                                    onHoverNode?(nodeList[index], hover)
                                }
                ).position(x: scalePoint(nodeList[index].point).x, y: scalePoint(nodeList[index].point).y)
                    .onTapGesture {
                        onTouchPoint?(nodeList[index])
                        print("location: \(scalePoint(nodeList[index].point).x)")
                    }
            }
            
            if normalState == .disabled, let connectedNodeInfo = connectedNodeInfo {
                // multiple hop connected node point
                if let multipleHop = connectedNodeInfo as? MultiHopResult {
                    if let entryNode = multipleHop.entry?.city?.toNodePoint(), let nodePos = computNodePointPos(node: entryNode), let exitNode = multipleHop.exit?.city?.toNodePoint(), let nodePos2 = computNodePointPos(node: exitNode) {
                        let connectPoint = ConnectPoint(point1: nodePos, point2: nodePos2)
                        Canvas { context, _ in
                            context.stroke(connectPoint.buildPath(scale: 1), with: .linearGradient(lineGradient, startPoint: connectPoint.point1, endPoint: connectPoint.point2), lineWidth: 2)
                        }
                        .allowsHitTesting(false)
                        
                        VpnMapPointView(state: .activeDisabled,
                                        locationIndex: 1,
                                        onHoverNode: { hover in
                                            onHoverNode?(entryNode, hover)
                                        }
                        ).position(x: nodePos.x, y: nodePos.y)
                            .onTapGesture {
                                onTouchPoint?(entryNode)
                            }
                        
                        VpnMapPointView(state: .activated,
                                        locationIndex: 2,
                                        onHoverNode: { hover in
                                            onHoverNode?(exitNode, hover)
                                        }
                        ).position(x: nodePos2.x, y: nodePos2.y)
                            .onTapGesture {
                                onTouchPoint?(exitNode)
                            }
                    }
                }
                // single connected node point
                else if let node = connectedNodeInfo.toNodePoint(), let nodePos = computNodePointPos(node: node) {
                    VpnMapPointView(state: .activated,
                                    locationIndex: node.info.localtionIndex,
                                    onHoverNode: { hover in
                                        onHoverNode?(node, hover)
                                    }
                    ).position(x: nodePos.x, y: nodePos.y)
                        .onTapGesture {
                            onTouchPoint?(node)
                        }
                }
            }
        }
    }
    
    func computNodePointPos(node: NodePoint) -> CGPoint {
        var point: CGPoint = scalePoint(node.point)
        if !isShowCity {
            if let l2Point = node.l2Point {
                point = scalePoint(l2Point)
            }
        }
        return point
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
