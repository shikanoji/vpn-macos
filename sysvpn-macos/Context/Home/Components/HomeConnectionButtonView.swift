//
//  HomeConnectionButtonView.swift
//  sysvpn-macos
//
//  Created by macbook on 21/10/2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct HomeConnectionButtonView : View {
    @EnvironmentObject var appState: GlobalAppStates
    var onTap: ( () -> Void)?
   @State var displayAppState: AppDisplayState = .disconnected
   @State var lastAppState: AppDisplayState = .disconnected
    
    var nodeIcon : some View {
        HStack {
            if let image = appState.connectedNode?.image {
                image.resizable()
                    .frame(width: 76,height: 76)
                    .overlay {
                        RoundedRectangle(cornerRadius: 38).stroke(style: .init(lineWidth: 4))
                            .foregroundColor(.white)
                    }
                    
            }
        }
    }
    var connectedButtonView : some View {
        VStack {
            nodeIcon
            Spacer().frame(height: 20)
            HStack (spacing: 5)  {
                Text("VPN IP: ").font(.system(size: 14))
                Text(appState.serverInfo?.ipAddress ?? "0.0.0.0")
                    .font(.system(size: 14, weight: .semibold))
            }
            Spacer().frame(height: 10)
            HStack (spacing: 5) {
                Text("Location: ")
                    .font(.system(size: 14))
                Text(appState.connectedNode?.locationSubname ?? appState.connectedNode?.locationName ?? "")
                    .font(.system(size: 14, weight: .semibold))
            }
            
            Spacer().frame(height: 20)
            if displayAppState == .disconnecting {
                Button {
                    
                } label: {
                    AppActivityIndicator()
                     //   .font(Font.system(size: 14, weight: .semibold))
                }
                .buttonStyle(LoginButtonCTAStyle(bgColor: Color(hexString: "FFFFFF")))
            } else {
                Button {
                    lastAppState = displayAppState
                    displayAppState = .disconnecting
                    onTap?()
                } label: {
                    Text(L10n.Login.disconnect)
                        .font(Font.system(size: 14, weight: .semibold))
                }
                .buttonStyle(LoginButtonCTAStyle(bgColor: Color(hexString: "FFFFFF")))
            }
        }
        .foregroundColor(Color.white)
    }
    
    var connectButtonView : some View {
        ZStack {
            ButtonOutlinePathShape()
                .stroke(style: .init(lineWidth: 4 ))
                .foregroundColor(displayAppState == .connecting  ?  Asset.Colors.primaryColor.swiftUIColor : .white )
                .padding(5)
                .frame(width: 140, height: 140)
            Rectangle().clipShape(ButtonOutlinePathShape())
                .foregroundColor( displayAppState == .connecting  ? .white : Asset.Colors.primaryColor.swiftUIColor)
                .padding(12)
                .frame(width: 140, height: 140)
            
            if displayAppState == .disconnected {
                Text("Quick\nConnect")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Asset.Colors.backgroundColor.swiftUIColor)
            } else {
                AppActivityIndicator(color: Asset.Colors.backgroundColor.swiftUIColor)
            }
            
        }
    }
    var body: some View {
        VStack {
            Text((displayAppState == .connected) ? "VPN connected" :  "VPN not connected")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.white)
            Spacer().frame(height: 24)
           /* connectButtonView.onTapGesture {
                onTap?()
            }*/
            if displayAppState == .connected || ( lastAppState == .connected &&  displayAppState == .disconnecting)  {
                connectedButtonView
            } else {
                connectButtonView.onTapGesture {
                    onTap?()
                }
            }
            Spacer()
                
        }.onChange(of: appState.displayState) { newValue in
           
            if displayAppState != newValue {
                lastAppState = displayAppState
                withAnimation {
                    displayAppState = newValue
                }
            }
            
        }.onAppear() {
            displayAppState = appState.displayState
            lastAppState = displayAppState
        }
    }
}

struct ButtonOutlinePathShape : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: rect.width / 2, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
        
        return path
    }
    
    
}

struct HomeConnectionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeConnectionButtonView( displayAppState: .connected)
    }
}



