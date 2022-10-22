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
    var isShowCity: Bool = false
    
    @EnvironmentObject var appState: GlobalAppStates
    
    @State var tooltipNodeX: CGFloat = 0
    @State  var tooltipNodeY: CGFloat  = 0
    
    var tooltipNodeName: String {
        return nodePoint?.info.locationName ?? ""
    }
    
    var idName:String {
        return (nodePoint?.info.locationDescription ?? "") + tooltipNodeName
    }
    
    var localDescription: String? {
        return nodePoint?.locationDescription
    }
    
    
    var tooltipInfo : some View {
        Spacer()
            .frame(width: 1, height: 1, alignment: .center)
            .modifier(
                MapTooltipModifier(name: idName, enabled: nodePoint != nil, config: AppTooltipConfig(), content: {
                    VStack {
                        if nodePoint?.info.locationSubname != nil {
                            Text(nodePoint?.info.locationSubname ?? "").foregroundColor(Color.black)
                                .font(Font.system(size: 14, weight: .medium))
                            Rectangle().frame(height: 1)
                                .background(Asset.Colors.subTextColor.swiftUIColor)
                        }
                        HStack {
                            if nodePoint?.info.image != nil {
                                nodePoint?.info.image?.resizable().frame(width: 32, height: 32, alignment: .center)
                            }
                            VStack(alignment: .leading) {
                                Text(tooltipNodeName).foregroundColor(Color.black)
                                    .font(Font.system(size: 14, weight: .medium))
                                if localDescription != nil {
                                    Spacer().frame(height: 5)
                                    Text(localDescription ?? "").foregroundColor(Color.black)
                                        .font(Font.system(size: 13, weight: .regular))
                                }
                                
                            }
                        }
                    }
                })
            )  .position(x: tooltipNodeX, y: tooltipNodeY)
    }
    
    var tooltipConnected : some View {
        Spacer()
            .frame(width: 1, height: 1, alignment: .center)
            .modifier(
                MapTooltipModifier(name: idName, enabled: nodePoint != nil, config: AppTooltipConfig(), content: {
                    VStack {
                       Text("Connected")
                            .foregroundColor(Color.black)
                    }
                })
            )  .position(x: tooltipNodeX, y: tooltipNodeY)
    }
    
    func body(content: Content) -> some View {
        VStack {
            content.overlay {
                
                if appState.displayState == .connected && appState.hoverNode != nodePoint {
                    tooltipConnected
                } else
                {
                    tooltipInfo
                }
            }
        }.onChange(of: nodePoint) { newValue in
            if nodePoint == nil {
                self.updateLocation(nodePoint: newValue)
            }
            else {
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
            updateLocation(nodePoint: nodePoint, vector: scaleVector,isShowCity: newValue)
        }
    }
    
    func updateLocation(nodePoint: NodePoint?, scale: Double? = nil, vector: Double? = nil, isShowCity: Bool? = nil) {
        guard let node = nodePoint else {
            return
        }
        let point = computNodePointPos(node: node, isShowCity: isShowCity ?? self.isShowCity)
        let scaleVector = vector ?? self.scaleVector
        let scaleValue = scale ?? self.scaleValue
        tooltipNodeX =  point.x * scaleVector * scaleValue / rescaleView
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

extension CGPoint {
    func toScalePoint(scaleVector: Double) -> CGPoint {
        return CGPoint(x: x * scaleVector  , y: y * scaleVector )
    }
}