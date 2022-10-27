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
    @State private var isShowCity = false
    @State private var isShowCityAnim = false
    let pub = NotificationCenter.default
        .publisher(for: .reloadServerStar)
    
    var leftMenuPannel: some View {
        ZStack {
            if viewModel.selectedMenuItem != .none {
                if viewModel.selectedMenuItem == .manualConnection {
                    
                    HomeListCountryNodeView(selectedItem: $viewModel.selectedMenuItem, countries: $viewModel.listCountry, isShowCity: $isShowCity, countrySelected: $viewModel.countrySelected,
                        onTouchItem:{item in
                            self.viewModel.connect(to: item)
                        }
                    )
                        .transition(
                            AnyTransition.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ).combined(with: .opacity))
                        HomeDetailCityNodeView(selectedItem: $viewModel.selectedMenuItem, listCity: $viewModel.listCity, isShowCity: $isShowCity, countryItem: viewModel.countrySelected,
                           onTouchItem: { item in
                               self.viewModel.connect(to: item)
                           }
                        )
                            .transition(
                                AnyTransition.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                                ).combined(with: .opacity))
                            .offset(x: isShowCityAnim ? 0 : 400, y: 0)
                            .opacity(isShowCityAnim ?  1 : 0)
                     
                } else if viewModel.selectedMenuItem == .staticIp {
                    HomeListCountryNodeView(selectedItem: $viewModel.selectedMenuItem, countries: $viewModel.listStaticServer, isShowCity: $isShowCity, countrySelected: $viewModel.countrySelected,
                        onTouchItem:{item in
                            self.viewModel.connect(to: item)
                        }
                    )
                        .transition(
                            AnyTransition.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ).combined(with: .opacity))
                        .onReceive(pub) { _ in
                            if viewModel.selectedMenuItem == .staticIp {
                                viewModel.getListStaticServer(firstLoadData: false)
                            }
                        }
                } else if viewModel.selectedMenuItem == .multiHop {
                    HomeListCountryNodeView(selectedItem: $viewModel.selectedMenuItem, countries: $viewModel.listMultiHop, isShowCity: $isShowCity, countrySelected: $viewModel.countrySelected,
                        onTouchItem:{item in
                            self.viewModel.connect(to: item)
                        }
                    )
                        .transition(
                            AnyTransition.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ).combined(with: .opacity))
                }
                
            }
        }
        .clipped()
        .onChange(of: isShowCity) { value in
            withAnimation {
                isShowCityAnim = value
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0){
            HomeLeftPanelView(selectedItem: $viewModel.selectedMenuItem)
                .frame(width: 240)
                .contentShape(Rectangle())
                .zIndex(3)
            if viewModel.selectedMenuItem != .none {
                leftMenuPannel.modifier(HomeListWraperView(
                    onClose: {
                        self.viewModel.selectedMenuItem = .none
                    }
                  )
                )
                .zIndex(2)
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
                            .font(.system(size: 18, weight: .thin))
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
                        HomeZoomSliderView(value: $zoomValue, step: 0.1, sliderRange: 1...2)
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
            
        }.frame(minWidth: 1000, minHeight: 650)
        .onChange(of: appState.displayState) { newValue in
            withAnimation {
                localIsConnected = newValue == .connected
            }
        }
        .onAppear() {
            localIsConnected = appState.displayState == .connected 
        }
        .onChange(of: viewModel.selectedMenuItem) { newValue in
            viewModel.onChangeState()
        }
        .onChange(of: viewModel.countrySelected) { newValue in
            viewModel.onChangeCountry(item: newValue)
        }
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GlobalAppStates.shared)
    }
}
