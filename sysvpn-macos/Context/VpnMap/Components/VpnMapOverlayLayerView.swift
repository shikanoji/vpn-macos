//
//  VpnMapOverlayLayerView.swift
//  sysvpn-macos
//
//  Created by macbook on 22/10/2022.
//

import Foundation
import SwiftUI

struct VpnMapOverlayLayer: ViewModifier {
    var scaleVector: CGFloat
    var scaleValue: CGFloat
    var rescaleView: CGFloat
    var nodePoint: NodePoint?
    var connectedNode: NodePoint?
    var isShowCity: Bool = false
    
    @EnvironmentObject var appState: GlobalAppStates
    @EnvironmentObject var mapState: MapAppStates
    
    @State var tooltipNodeX: CGFloat = 0
    @State var tooltipNodeY: CGFloat = 0
    
    @State var connectedPosition: CGPoint = .zero
    
    var computedScale: Double {
        return scaleVector * scaleValue / rescaleView
    }

    var tooltipNodeName: String {
        return nodePoint?.info.locationName ?? ""
    }
    
    var idName: String {
        return (nodePoint?.info.locationDescription ?? "") + tooltipNodeName
    }
    
    var localDescription: String? {
        return nodePoint?.locationDescription
    }
    
    var tooltipInfo: some View {
        Spacer()
            .frame(width: 1, height: 1, alignment: .center)
            .modifier(
                MapTooltipModifier(name: idName, enabled: nodePoint != nil && nodePoint != connectedNode, config: AppTooltipConfig(), content: {
                    if let nodePoint = nodePoint {
                        MapTooltipLocalInfo(nodePoint: nodePoint, tooltipNodeName: tooltipNodeName, tooltipDesc: localDescription)

                    } else {
                        Spacer().frame(width: 100, height: 10)
                    }
                })
            ).position(x: tooltipNodeX, y: tooltipNodeY)
    }
    
    var tooltipConnectedText: some View {
        Spacer()
            .frame(width: 1, height: 1, alignment: .center)
            .modifier(
                MapTooltipModifier(name: "connected", enabled: connectedNode != nil, config: AppTooltipConfig(), content: {
                    VStack {
                        Text("Connected")
                            .foregroundColor(Color.black)
                    }
                })
            )
            .offset(CGSize(width: 0, height: 10 * scaleValue))
            .position(connectedPosition.toScalePoint(scaleVector: computedScale))
    }
    
    var tooltipConnectedNode: some View {
        Spacer()
            .frame(width: 1, height: 1, alignment: .center)
            .modifier(
                MapTooltipModifier(name: connectedNode?.info.locationName ?? "",
                                   enabled: appState.displayState == .connected,
                                   config: AppTooltipConfig(),
                                   content: {
                                       if let node = connectedNode {
                                           MapTooltipLocalInfo(nodePoint: node, tooltipNodeName: node.info.locationName, tooltipDesc: node.locationDescription)
                                       } else {
                                           Spacer().frame(width: 100, height: 10)
                                       }
                                           
                                   })
            )
            .offset(CGSize(width: 0, height: 10 * scaleValue))
            .position(connectedPosition.toScalePoint(scaleVector: computedScale))
    }
    
    var isShowConnectedNode: Bool {
        if connectedPosition.x == 0 && connectedPosition.y == 0 {
            return false
        }
        return appState.displayState == .connected && !(mapState.connectedNode is MultiHopResult)
    }

    func body(content: Content) -> some View {
        VStack {
            content.overlay {
                tooltipInfo
                
                tooltipConnectedText.opacity((isShowConnectedNode && mapState.hoverNode != connectedNode) ? 1 : 0)
                tooltipConnectedNode.opacity((!isShowConnectedNode || mapState.hoverNode != connectedNode) ? 0 : 1)
            }
        }.onChange(of: nodePoint) { newValue in
            if nodePoint == nil {
                self.updateLocation(nodePoint: newValue)
            } else {
                withAnimation {
                    updateLocation(nodePoint: newValue)
                }
            }
        }
        .onChange(of: scaleValue) { newValue in
            updateLocation(nodePoint: nodePoint, scale: newValue)
        }
        .onChange(of: scaleVector) { newValue in
            updateLocation(nodePoint: nodePoint, vector: newValue)
        }.onChange(of: isShowCity) { newValue in
            updateLocation(nodePoint: nodePoint, vector: scaleVector, isShowCity: newValue)
            if let node = connectedNode {
                connectedPosition = computNodePointPos(node: node, isShowCity: newValue)
            }
        }.onChange(of: connectedNode) { newValue in
            if let node = newValue {
                connectedPosition = computNodePointPos(node: node, isShowCity: isShowCity)
            }
        }
    }
    
    func updateLocation(nodePoint: NodePoint?, scale: Double? = nil, vector: Double? = nil, isShowCity: Bool? = nil) {
        guard let node = nodePoint else {
            return
        }
        let point = computNodePointPos(node: node, isShowCity: isShowCity ?? self.isShowCity)
        let scaleVector = vector ?? self.scaleVector
        let scaleValue = scale ?? self.scaleValue
        tooltipNodeX = point.x * scaleVector * scaleValue / rescaleView
        tooltipNodeY = (point.y + 10) * scaleVector * scaleValue / rescaleView
    }
    
    func computNodePointPos(node: NodePoint, isShowCity: Bool) -> CGPoint {
        var point: CGPoint = node.point
        if !isShowCity {
            if let l2Point = node.l2Point {
                point = l2Point
            }
        }
        return point
    }
}

struct MapTooltipLocalInfo: View {
    var nodePoint: NodePoint
    var tooltipNodeName: String
    var tooltipDesc: String?
    var body: some View {
        VStack {
            if nodePoint.info.locationSubname != nil {
                Text(nodePoint.info.locationSubname ?? "").foregroundColor(Color.black)
                    .font(Font.system(size: 14, weight: .medium))
                Rectangle().frame(height: 1)
                    .background(Asset.Colors.subTextColor.swiftUIColor)
            }
            HStack {
                if nodePoint.info.image != nil {
                    nodePoint.info.image?.resizable().frame(width: 32, height: 32, alignment: .center)
                }
                VStack(alignment: .leading) {
                    Text(tooltipNodeName).foregroundColor(Color.black)
                        .font(Font.system(size: 14, weight: .medium))
                    if tooltipDesc != nil {
                        Spacer().frame(height: 5)
                        Text(tooltipDesc ?? "").foregroundColor(Color.black)
                            .font(Font.system(size: 13, weight: .regular))
                    }
                }
            }
        }
    }
}

extension CGPoint {
    func toScalePoint(scaleVector: Double) -> CGPoint {
        return CGPoint(x: x * scaleVector, y: y * scaleVector)
    }
}
