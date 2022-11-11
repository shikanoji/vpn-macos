//
//  HomeConnectionButtonView.swift
//  sysvpn-macos
//
//  Created by macbook on 21/10/2022.
//

import Foundation
import Kingfisher
import SwiftUI

struct HomeConnectionButtonView: View {
    @EnvironmentObject var appState: GlobalAppStates
    @EnvironmentObject var mapState: MapAppStates
    
    var onTap: (() -> Void)?
    @State var displayAppState: AppDisplayState = .disconnected
    @State var lastAppState: AppDisplayState = .disconnected
    
    var nodeIcon: some View {
        HStack {
            if let multipleHop = mapState.connectedNode as? MultiHopResult,
               let image1 = multipleHop.entry?.country?.image,
               let image2 = multipleHop.exit?.country?.image {
                ZStack {
                    image1.resizable()
                        .frame(width: 46, height: 46)
                        .overlay {
                            RoundedRectangle(cornerRadius: 23).stroke(style: .init(lineWidth: 4))
                                .foregroundColor(.white)
                        }.transformEffect(.init(translationX: -20, y: 0))
                        .opacity(0.3)
                    image2.resizable()
                        .frame(width: 66, height: 66)
                        .overlay {
                            RoundedRectangle(cornerRadius: 33).stroke(style: .init(lineWidth: 4))
                                .foregroundColor(.white)
                        }.transformEffect(.init(translationX: 20, y: 0))
                }
               
            } else
            if let image = mapState.connectedNode?.image {
                image.resizable()
                    .frame(width: 66, height: 66)
                    .overlay {
                        RoundedRectangle(cornerRadius: 33).stroke(style: .init(lineWidth: 4))
                            .foregroundColor(.white)
                    }
            }
        }
    }
    
    var connectedButtonView: some View {
        VStack {
            nodeIcon
            Spacer().frame(height: 20)
            HStack(spacing: 5) {
                Text(L10n.Global.labelVPNIP).font(.system(size: 14))
                Text(mapState.serverInfo?.ipAddress ?? "0.0.0.0")
                    .font(.system(size: 12, weight: .semibold))
            }
            Spacer().frame(height: 6)
            HStack(spacing: 5) {
                Text(L10n.Global.labelLocation)
                    .font(.system(size: 12))
                Text(mapState.connectedNode?.locationSubname ?? mapState.connectedNode?.locationName ?? "")
                    .font(.system(size: 12, weight: .semibold))
            }
            
            Spacer().frame(height: 24)
            if displayAppState == .disconnecting {
                Button {} label: {
                    AppActivityIndicator()
                }
                .buttonStyle(LoginButtonCTAStyle(bgColor: Color(hexString: "FFFFFF")))
            } else {
                Button {
                    lastAppState = displayAppState
                    withAnimation {
                        displayAppState = .disconnecting
                    }
                    onTap?()
                } label: {
                    Text(L10n.Login.disconnect)
                        .font(Font.system(size: 12, weight: .semibold))
                }
                .buttonStyle(LoginButtonCTAStyle(bgColor: Color(hexString: "FFFFFF")))
                .frame(width: 114)
            }
        }
        .foregroundColor(Color.white)
    }
    
    var connectButtonView: some View {
        ZStack {
            ButtonOutlinePathShape()
                .stroke(style: .init(lineWidth: 4))
                .foregroundColor(displayAppState == .connecting ? Asset.Colors.primaryColor.swiftUIColor : .white)
                .padding(3)
                .frame(width: 100, height: 100)
            Rectangle().clipShape(ButtonOutlinePathShape())
                .foregroundColor(displayAppState == .connecting ? .white : Asset.Colors.primaryColor.swiftUIColor)
                .padding(9)
                .frame(width: 100, height: 100)
            
            if displayAppState == .disconnected {
                Text(L10n.Global.quickConnect)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Asset.Colors.backgroundColor.swiftUIColor)
            } else {
                AppActivityIndicator(color: Asset.Colors.backgroundColor.swiftUIColor)
            }
        }
    }

    var body: some View {
        VStack {
            Text((displayAppState == .connected) ? L10n.Global.vpnConnected : L10n.Global.vpnNotConnected)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.white)
            Spacer().frame(height: 24)
            
            if displayAppState == .connected {
                connectedButtonView
            } else {
                connectButtonView.onTapGesture {
                    onTap?()
                }
            }
            Spacer().frame(maxHeight: 46)
                
        }.onChange(of: appState.displayState) { newValue in
           
            if displayAppState != newValue {
                lastAppState = displayAppState
                withAnimation {
                    displayAppState = newValue
                }
            }
            
        }.onAppear {
            displayAppState = appState.displayState
            lastAppState = displayAppState
        }
    }
}

struct ButtonOutlinePathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 2, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
        
        return path
    }
}

struct HomeConnectionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeConnectionButtonView(displayAppState: .connected)
            .environmentObject(GlobalAppStates.shared)
            .environmentObject(MapAppStates.shared)
            .frame(width: 240, height: 400)
    }
}
