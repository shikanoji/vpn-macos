//
//  SplashView.swift
//  sysvpn-macos
//
//  Created by doragon on 29/09/2022.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @StateObject private var model = SplashViewModel()
    @State private var animate = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Asset.Assets.bgLoading.swiftUIImage
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
               
                VStack {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Asset.Colors.outlightColor.swiftUIColor.opacity(0.12), Asset.Colors.outlightColor.swiftUIColor.opacity(0)], center: .center, startRadius: .zero, endRadius: model.outLightSize / 2))
                            .frame(width: model.outLightSize,
                                   height: model.outLightSize,
                                   alignment: .center)
                            .modifier(MyEffect(x: animate ? 1 : 0.8, width: model.outLightSize))
                        Asset.Assets.logoF1.swiftUIImage
                            .resizable()
                            .frame(width: model.logoSize.width, height: model.logoSize.height, alignment: .center)
                    }
                    Text(L10n.Login.appName).font(Font.system(size: 26, weight: .bold)).padding(.bottom, 8)
                    Text(L10n.Login.sologanProcessing).padding(.bottom, 48)
                }
                
            }.background(Asset.Colors.backgroundColor.swiftUIColor)
                .foregroundColor(Color.white)
        }.onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
