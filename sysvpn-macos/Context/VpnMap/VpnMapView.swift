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
    @EnvironmentObject var appState: GlobalAppStates
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
                },
                isShowCity: isShowCity
            )
            .scaledToFit()
            .clipShape(Rectangle())
            .modifier(ZoomModifier(contentSize: CGSize(width: proxy.size.height * aspecRaito, height: proxy.size.height), screenSize: proxy.size, numberImage: numberImage, currentScale: $scale,
                                   cameraPosition: $updateCameraPosition,
                                   overlayLayer: VpnMapOverlayLayer(
                                    scaleVector: scaleVector * proxy.size.height / baseHeight  * rescaleView, scaleValue: scale,
                                    rescaleView: rescaleView,
                                    nodePoint: selectedNode,
                                    isShowCity: isShowCity
                                   ) ))
      
        .simultaneousGesture(TapGesture().onEnded {
            if appState.displayState == .disconnected {
                selectedNode = nil
            }
        })
        .clipped()
        .onChange(of: scale) { newValue in
            isShowCity =  scale > 1.5
        }.onChange(of: isShowCity, perform: { newValue in
            if appState.displayState != .connected {
                selectedNode = nil
            }
        }).onChange(of: selectedNode, perform: { newValue in
            appState.selectedNode = newValue?.info
            updateCameraPosition = newValue?.point.toScalePoint(scaleVector: scaleVector * proxy.size.height / baseHeight)
        })
        .onChange(of: appState.displayState, perform: { newValue in
            if appState.displayState == .connected  || appState.displayState == .connecting {
                if appState.connectedNode != nil {
                    selectedNode = appState.connectedNode?.toNodePoint(appState.serverInfo?.ipAddress)
                    updateCameraPosition = selectedNode?.point.toScalePoint(scaleVector: scaleVector * proxy.size.height / baseHeight)
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
    var isShowCity: Bool = false
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
            onHoverNode: onHoverNode,
            isShowCity: isShowCity
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

struct VpnMapView_Previews: PreviewProvider {
    @State static var value: CGFloat = 1
    static var previews: some View {
        VpnMapView(scale: $value)
    }
}

