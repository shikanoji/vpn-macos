//
//  LoginLoadingView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/09/2022.
//

import Foundation
import SwiftUI

struct LoginLoadingView: View {
    @Binding var isShowing: Bool
    @State private var animate = true
    private let outLightSize: CGFloat = 300
    private let logoSize = CGSize(width: 100, height: 116)
    
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
                                        Asset.Colors.outlightColor.swiftUIColor.opacity(0.1), Asset.Colors.outlightColor.swiftUIColor.opacity(0)], center: .center, startRadius: .zero, endRadius: outLightSize / 2))
                            .frame(width: outLightSize,
                                   height: outLightSize,
                                   alignment: .center)
                            .modifier(MyEffect(x: animate ? 1 : 0.8, width: outLightSize))
                        Asset.Assets.logoF1.swiftUIImage
                            .resizable()
                            .frame(width: logoSize.width, height: logoSize.height, alignment: .center)
                    }
                    Text(L10n.Login.appName).font(Font.system(size: 26, weight: .bold)).padding(.bottom, 8)
                    Text(L10n.Login.sologanProcessing).padding(.bottom, 48)
                }
                
            }.background(Asset.Colors.backgroundColor.swiftUIColor)
                .foregroundColor(Color.white)
                .opacity(self.isShowing ? 1 : 0)
        }.onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animate.toggle()
                print("123213")
            }
        }
    }
}

struct MyEffect: GeometryEffect {
    var x: CGFloat = 0
    var width: CGFloat = 0
    
    var animatableData: CGFloat {
        get { x }
        set { x = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let newWidth = width * x
        let newHeight = width * x
        
        return ProjectionTransform(CGAffineTransform(scaleX: x, y: x)
            .translatedBy(x: (width - newWidth) / 2, y: (width - newHeight) / 2))
    }
}
