//
//  VpnMapView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip

struct VpnMapView: View {
    @Binding var scale: CGFloat
    var rescaleView: CGFloat = 1.5
    var numberImage = 1
    var aspecRaito: CGFloat = 1024 / 588
    var baseHeight: CGFloat = 588
    var scaleVector: CGFloat = 1
    @State var selectedNode: NodePoint? = nil
    var connectPoints: [ConnectPoint] = [
        ConnectPoint(point1: CGPoint(x: 100, y: 100), point2: CGPoint(x: 400, y: 500))
    ]
    var nodeList: [NodePoint] = [
        NodePoint(point: CGPoint(x: 400, y: 500), info: NodeInfoTest(state: .activated, localtionIndex: 1)),
        NodePoint(point: CGPoint(x: 100, y: 100), info: NodeInfoTest(state: .activeDisabled, localtionIndex: 2)),
        NodePoint(point: CGPoint(x: 300, y: 200), info: NodeInfoTest(state: .disabled)),
        NodePoint(point: CGPoint(x: 350, y: 220), info: NodeInfoTest(state: .normal))
    ]
    
    
    var body: some View {
        GeometryReader { proxy in
            LoopMapView(
                size: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height),
                scale: rescaleView,
                loop: numberImage,
                scaleVector: scaleVector * proxy.size.height / baseHeight,
                connectPoints: connectPoints,
                nodeList: nodeList,
                
                onTouchPoint: { node in
                    self.selectedNode = node
                }
            )
            .scaledToFit()
            .clipShape(Rectangle())
            .modifier(ZoomModifier(contentSize: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height), screenSize: proxy.size, numberImage: numberImage, currentScale: $scale,
                                   overlayLayer: VpnMapOverlayLayer(
                                       scaleVector: scaleVector * proxy.size.height / baseHeight, scaleValue: scale,
                                       rescaleView: rescaleView,
                                       nodePoint: selectedNode)))
        }
        .simultaneousGesture(TapGesture().onEnded {
            selectedNode = nil
        }).clipped()
    }
}

struct LoopMapView: View {
    var size: CGSize
    var scale: CGFloat = 1.5
    var loop: Int
    var scaleVector: CGFloat = 1.5
    var connectPoints: [ConnectPoint]
    var nodeList: [NodePoint]
    var onTouchPoint: ((NodePoint) -> Void)?
    var mapLayer1: some View {
        Asset.Assets.mapLayer1.swiftUIImage.resizable()
            .frame(width: size.width * scale, height: size.height * scale)
    }
    
    var pointLayer: some View {
        VpnMapPointLayerView(
            connectPoints: connectPoints, nodeList: nodeList,
            scaleVector: scaleVector,
            onTouchPoint: onTouchPoint
        )
        .frame(width: size.width * scale, height: size.height * scale)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            HStack(spacing: 0) {
                ForEach(0..<loop, id: \.self) { _ in
                    mapLayer1
                }
            }
            HStack(spacing: 0) {
                ForEach(0..<loop, id: \.self) { _ in
                    pointLayer
                }
            }
        }.frame(width: size.width * CGFloat(loop) * scale, height: size.height * scale, alignment: .center).scaleEffect(1 / scale)
    }
}

struct VpnMapOverlayLayer: ViewModifier {
    var scaleVector: CGFloat
    var scaleValue: CGFloat
    var rescaleView: CGFloat
    var nodePoint: NodePoint?
    
    var tooltipNodeX: CGFloat {
        return (nodePoint?.point.x ?? 0) * scaleVector * scaleValue / rescaleView
    }

    var tooltipNodeY: CGFloat {
        return ((nodePoint?.point.y ?? 0) + 10) * scaleVector * scaleValue / rescaleView
    }
    
    var tooltipNodeName: String {
        return nodePoint?.info.name ?? ""
    }

    func body(content: Content) -> some View {
        content.overlay {
            Spacer()
                .frame(width: 1, height: 1, alignment: .center)
                .tooltip(
                    nodePoint != nil,
                    config: AppTooltipConfig(),
                    content: {
                        HStack {
                            if nodePoint?.info.image != nil {
                                nodePoint?.info.image?.resizable().frame(width: 32, height: 32, alignment: .center)
                            }
                            VStack(alignment: .leading) {
                                Text(tooltipNodeName).foregroundColor(Color.black)
                                    .font(Font.system(size: 14, weight: .medium))
                                Text(tooltipNodeName).foregroundColor(Color.black)
                                    .font(Font.system(size: 13, weight: .regular))
                            }
                        }
                    })
                .position(x: tooltipNodeX, y: tooltipNodeY)
        }
    }
}

struct VpnMapView_Previews: PreviewProvider {
    @State static var value: CGFloat = 1
    static var previews: some View {
        VpnMapView(scale: $value)
    }
}
