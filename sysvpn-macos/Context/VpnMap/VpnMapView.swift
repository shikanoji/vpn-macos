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
    @EnvironmentObject var mapState: MapAppStates
    @EnvironmentObject var appState: GlobalAppStates
    @Binding var scale: CGFloat
   
    var rescaleView: CGFloat = 1.1
    var numberImage = 1
    var aspecRaito: CGFloat = 2048 / 1588
    var baseHeight: CGFloat = 588
    var scaleVector: CGFloat = 1
    @State var isShowCity = false
    @State var selectedNode: NodePoint? = nil
    @State var connectedNode: NodePoint? = nil
    var connectPoints: [ConnectPoint] = []
    @State var updateCameraPosition: CGPoint? = .zero
    @State var screenSize: CGSize = .init(width: 100, height: 100)
    var size: CGSize
    @Binding var disableScrollZoom: Bool
    var body: some View {
        VStack {
            LoopMapView(
                connectedNodeInfo: mapState.connectedNode,
                size: CGSize(width: screenSize.height * aspecRaito, height: screenSize.height),
                scale: rescaleView,
                loop: numberImage,
                scaleVector: scaleVector * screenSize.height / baseHeight * rescaleView,
                connectPoints: connectPoints,
                nodeList: viewModel.listCountry, // isShowCity ? viewModel.listCity : viewModel.listCountry,
                onTouchPoint: { node in
                    selectedNode = node
                    mapState.selectedNode = node.info
                }, onHoverNode: {
                    node, hover in
                    if node != connectedNode {
                        return
                    }
                    if hover {
                        mapState.hoverNode = node
                    } else {
                        mapState.hoverNode = nil
                    }
                },
                isShowCity: isShowCity
            )
            .scaledToFit()
            .clipShape(Rectangle())
            .modifier(ZoomModifier(contentSize: CGSize(width: screenSize.height * aspecRaito, height: screenSize.height), screenSize: $screenSize, numberImage: numberImage, currentScale: $scale,
                                   cameraPosition: $updateCameraPosition,
                                   overlayLayer: VpnMapOverlayLayer(
                                       scaleVector: scaleVector * screenSize.height / baseHeight * rescaleView, scaleValue: scale,
                                       rescaleView: rescaleView,
                                       nodePoint: selectedNode,
                                       connectedNode: connectedNode,
                                       isShowCity: isShowCity
                                   ),
                                   disableZoom: $disableScrollZoom))
      
            .simultaneousGesture(TapGesture().onEnded {
                selectedNode = nil
            })
            .onChange(of: scale) { _ in
                withAnimation {
                    isShowCity = scale > 1.5
                }
            }.onChange(of: isShowCity, perform: { _ in
                selectedNode = nil
            }).onChange(of: selectedNode, perform: { newValue in
                mapState.selectedNode = newValue?.info
                updateCameraPosition = newValue?.point.toScalePoint(scaleVector: scaleVector * screenSize.height / baseHeight)
            })
            .onChange(of: appState.displayState, perform: { value in
                if value == .connected || value == .connecting {
                    if mapState.connectedNode != nil {
                        connectedNode = mapState.connectedNode?.toNodePoint(mapState.serverInfo?.ipAddress)
                       
                        if let multipleHop = mapState.connectedNode as? MultiHopResult {
                            if let entryNode = multipleHop.entry?.country?.toNodePoint(), let exitNode = multipleHop.exit?.country?.toNodePoint() {
                                let newX = (entryNode.point.x + exitNode.point.x) / 2 * scaleVector * screenSize.height / baseHeight
                                let newY = (entryNode.point.y + exitNode.point.y) / 2 * scaleVector * screenSize.height / baseHeight
                                
                                let centerPoint = CGPoint(x: newX, y: newY)
                                let newScale = max(1, 2 - abs(entryNode.point.x - exitNode.point.x + 200) / screenSize.width)
                                if newScale < scale {
                                    withAnimation {
                                        scale = newScale
                                    }
                                }
                                 
                                updateCameraPosition = centerPoint
                            }
                        } else {
                            updateCameraPosition = connectedNode?.point.toScalePoint(scaleVector: scaleVector * screenSize.height / baseHeight)
                        }
                        return
                    } else {
                        updateCameraPosition = nil
                    }
                } else if value == .disconnected {
                    updateCameraPosition = nil
                }
            
                selectedNode = nil
            })
            .onChange(of: viewModel.isLoaded, perform: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let node = mapState.connectedNode, appState.displayState == .connected {
                        self.selectedNode = nil
                        self.connectedNode = node.toNodePoint(mapState.serverInfo?.ipAddress)
                        updateCameraPosition = connectedNode?.point.toScalePoint(scaleVector: scaleVector * screenSize.height / baseHeight)
                    }
                }
            }).onChange(of: size) { newValue in
                screenSize = CGSize(width: newValue.width, height: newValue.height + 100)
            }
            .onAppear {
                screenSize = CGSize(width: size.width, height: size.height + 100)
            }
        }
    }
}

struct LoopMapView: View {
    var connectedNodeInfo: INodeInfo?
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
            /* HStack(spacing: 0) {
                 ForEach(0..<loop, id: \.self) { _ in
                     mapLayer1
                 }
             }
             HStack(spacing: 0) {
                 ForEach(0..<loop, id: \.self) { _ in
                     pointLayer
                 }
             } */
            mapLayer1
            pointLayer
        }.frame(width: size.width * CGFloat(loop) * scale, height: size.height * scale, alignment: .center).scaleEffect(1 / scale)
    }
}
 