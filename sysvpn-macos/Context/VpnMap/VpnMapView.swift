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
    @StateObject private var viewModel = VpnMapViewModel()
    @StateObject private var appState = GlobalAppStates.shared
    @Binding var scale: CGFloat
    var rescaleView: CGFloat = 2
    var numberImage = 1
    var aspecRaito: CGFloat = 1024 / 588
    var baseHeight: CGFloat = 588
    var scaleVector: CGFloat = 1
    @State  var isShowCity = false
    @State var selectedNode: NodePoint? = nil
    var connectPoints: [ConnectPoint] = [  ]
    @State  var updateCameraPosition: CGPoint? = .zero;
    
    
    
    var body: some View {
        GeometryReader { proxy in
            LoopMapView(
                connectedNodeInfo: appState.connectedNode,
                size: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height),
                scale: rescaleView,
                loop: numberImage,
                scaleVector: scaleVector * proxy.size.height / baseHeight * rescaleView,
                connectPoints: connectPoints,
                nodeList: isShowCity ? viewModel.listCity : viewModel.listCountry,
                onTouchPoint: { node in
                    if appState.displayState == .disconnected {
                        self.selectedNode = node
                        appState.selectedNode = node.info
                    }
                }, onHoverNode: {
                    (node, hover) in
                    if node.info.state == .disabled {
                        return
                    }
                    
                    if hover {
                        appState.hoverNode = node
                    } else {
                        appState.hoverNode = nil
                    }
                }
            )
            .scaledToFit()
            .clipShape(Rectangle())
            .modifier(ZoomModifier(contentSize: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height), screenSize: proxy.size, numberImage: numberImage, currentScale: $scale,
                                   cameraPosition: $updateCameraPosition,
                                   overlayLayer: VpnMapOverlayLayer(
                                    scaleVector: scaleVector * proxy.size.height / baseHeight  * rescaleView, scaleValue: scale,
                                    rescaleView: rescaleView,
                                    nodePoint: selectedNode) ))
      
        .simultaneousGesture(TapGesture().onEnded {
            if appState.displayState == .disconnected {
                selectedNode = nil
            }
        })
        .clipped()
        .onChange(of: scale) { newValue in
            if appState.displayState == .disconnected {
               // selectedNode = nil
                isShowCity =  scale > 1.7
            }
        }.onChange(of: isShowCity, perform: { newValue in
            selectedNode = nil
        }).onChange(of: selectedNode, perform: { newValue in
            appState.selectedNode = newValue?.info
            updateCameraPosition = newValue?.point.toScalePoint(scaleVector: scaleVector * proxy.size.height / baseHeight)
        })
        .onChange(of: appState.displayState, perform: { newValue in
            if appState.displayState == .connected  || appState.displayState == .connecting {
                if appState.connectedNode != nil {
                    selectedNode = appState.connectedNode?.toNodePoint(appState.serverInfo?.ipAddress)
                } else {
                    selectedNode = nil
                }
            }else {
                selectedNode = nil
            }
        })
        .onChange(of: viewModel.isLoaded, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let node =  appState.connectedNode,  appState.displayState == .connected {
                    self.selectedNode = node.toNodePoint(appState.serverInfo?.ipAddress)
                }
            }
        })
        
        
    }
    }
}

struct LoopMapView: View {
    var connectedNodeInfo : INodeInfo?
    var size: CGSize
    var scale: CGFloat = 1.5
    var loop: Int
    var scaleVector: CGFloat = 3
    var connectPoints: [ConnectPoint]
    var nodeList: [NodePoint]
    var onTouchPoint: ((NodePoint) -> Void)?
    var onHoverNode: ((NodePoint, Bool) -> Void)?
    var mapLayer1: some View {
        Asset.Assets.mapLayer1.swiftUIImage.resizable()
            .frame(width: size.width * scale, height: size.height * scale)
    }
    
    var pointLayer: some View {
        VpnMapPointLayerView(
            connectedNodeInfo: connectedNodeInfo,
            connectPoints: connectPoints, nodeList: nodeList,
            scaleVector: scaleVector,
            onTouchPoint: onTouchPoint,
            onHoverNode: onHoverNode
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
    
    @StateObject var appState = GlobalAppStates.shared
    
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
        }
    }
    
    func updateLocation(nodePoint: NodePoint?, scale: Double? = nil, vector: Double? = nil) {
        if nodePoint == nil {
            return
        }
        let scaleVector = vector ?? self.scaleVector
        let scaleValue = scale ?? self.scaleValue
        tooltipNodeX =  (nodePoint?.point.x ?? 0) * scaleVector * scaleValue / rescaleView
        tooltipNodeY = ((nodePoint?.point.y ?? 0) + 10) * scaleVector * scaleValue / rescaleView
    }
}

struct VpnMapView_Previews: PreviewProvider {
    @State static var value: CGFloat = 1
    static var previews: some View {
        VpnMapView(scale: $value)
    }
}

extension CGPoint {
    func toScalePoint(scaleVector: Double) -> CGPoint {
        return CGPoint(x: x * scaleVector  , y: y * scaleVector )
    }
}
