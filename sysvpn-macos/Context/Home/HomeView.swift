//
//  HomeView.swift
//  sysvpn-macos
//
//  Created by doragon on 14/09/2022.
//

import SwiftUI

struct HomeView: View {
    @State var zoomValue: Double = 1
    @StateObject private var viewModel = HomeViewModel()
    @State var localIsConnected = false
    @EnvironmentObject var appState: GlobalAppStates
    var body: some View {
        HStack(spacing: 0){
            HomeLeftPanelView(selectedItem: $viewModel.selectedMenuItem)
                .frame(width: 300)
                .contentShape(Rectangle())
                .zIndex(3)
            if viewModel.selectedMenuItem != .none {
                HomeListCountryNodeView( selectedItem: $viewModel.selectedMenuItem)
                    .zIndex(2)
                    .transition(
                        AnyTransition.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                        
                    ))
            }
            VpnMapView(
                scale: $zoomValue.cgFloat()
            )
            .overlay() {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(colors: [
                                    Asset.Colors.mainBackgroundColor.swiftUIColor,
                                    Asset.Colors.mainLinearEndColor.swiftUIColor
                                ], startPoint: UnitPoint.top, endPoint: UnitPoint.bottom)
                            ).frame(height: 100)
                        Text(L10n.Global.locationMap)
                    }
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [
                                Asset.Colors.mainLinearEndColor.swiftUIColor,
                                Asset.Colors.backgroundColor.swiftUIColor
                            ], startPoint: UnitPoint.top, endPoint: UnitPoint.bottom)
                        ).frame(height: 200)
                }
                .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
            .edgesIgnoringSafeArea([.top])
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        HomeZoomSliderView(value: $zoomValue, step: 0.1, sliderRange: 1...1.5)
                            .frame(width: 112, height: 24, alignment: .center)
                        Spacer().frame(width: 16)
                    }
                    .frame( height: 100)
                    .edgesIgnoringSafeArea([.top])
                    
                    Spacer()
                    if localIsConnected {
                        HomeTrafficMonitorView()
                            .padding(.horizontal,50)
                            .padding(.bottom, 30)
                            .transition(
                                AnyTransition.asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .bottom)
                                
                            ))
                    } else {
                        HomeAlertConnectionView()
                            .transition(
                                AnyTransition.asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .bottom)
                                
                            ))
                    }
                    
                }
            }
            
        }.frame(minWidth: 1000, minHeight: 700)
        .onChange(of: appState.displayState) { newValue in
            withAnimation {
                localIsConnected = newValue == .connected
            }
        }
        .onAppear() {
            localIsConnected = appState.displayState == .connected
        }
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
