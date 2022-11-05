//
//  LoginBannerView.swift
//  sysvpn-macos
//
//  Created by macbook on 05/11/2022.
//

import Foundation
import SwiftUI

struct LoginBannerView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().fill(.radialGradient(colors: [Color(rgb: 0x2D6AB6),Color(rgb: 0x124B92)], center: .center, startRadius: .zero, endRadius: 500))
            
                Asset.Assets.logo.swiftUIImage
                    .resizable()
                    .frame(width: 167,height: 50)
                    .position(x: 134, y: 72)
            
            VStack{
                Asset.Assets.introImage.swiftUIImage
                Text("Exclusive Offer")
                    .font(.system(size: 24, weight: .semibold))
                Spacer().frame(height: 14)
                Text("Get your Free 30 days access")
                    .font(.system(size: 20))
                Spacer().frame(height: 30)
                Button {
                     
                } label: {
                    Text("Get offer now")
                        .font(.system(size: 16, weight: .medium))
                }.buttonStyle(LoginButtonCTAStyle(bgColor: Color.white))
                    .environment(\.isEnabled, true)
                    .frame(width: 130)
            }
             
        }
    }
}
struct LoginBannerView_Previews: PreviewProvider {
    static var previews: some View {
        LoginBannerView()
            .frame(minWidth: 500, minHeight: 500)
    }
}
