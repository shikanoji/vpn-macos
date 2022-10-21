//
//  BlinkingView.swift
//  sysvpn-macos
//
//  Created by macbook on 20/10/2022.
//

import Foundation
import SwiftUI
struct BlinkingView: View {
    @Binding private var isAnimating: Bool
        let count: UInt
        let spacing: CGFloat
        let size:CGFloat = 12;
        let cornerRadius: CGFloat
        let scaleRange: ClosedRange<Double>
        let opacityRange: ClosedRange<Double>
        let color: Color

        init(animate: Binding<Bool>,
                   count: UInt = 8,
                   spacing: CGFloat = 8,
                   cornerRadius: CGFloat = 8,
                   scaleRange: ClosedRange<Double> = (1...0),
                   opacityRange: ClosedRange<Double> = (0.25...1),
             color: Color = Color.black
        ) {
           self._isAnimating = animate
           self.count = count
           self.spacing = spacing
           self.cornerRadius = cornerRadius
           self.scaleRange = scaleRange
           self.opacityRange = opacityRange
            self.color = color
       }

        var body: some View {
           HStack (spacing: spacing){
               ForEach(0..<Int(count)) { index in
                   item(forIndex: index)
               }
           }
       }

       private var scale: CGFloat { CGFloat(isAnimating ? scaleRange.lowerBound : scaleRange.upperBound) }
       private var opacity: Double { isAnimating ? opacityRange.lowerBound : opacityRange.upperBound }

      
       private func item(forIndex index: Int) -> some View {
           RoundedRectangle(cornerRadius: cornerRadius,  style: .continuous)
               .frame(width: size, height: size)
               .opacity(opacity)
               .animation(
                   Animation
                       .default
                       .repeatCount(isAnimating ? .max : 1, autoreverses: true)
                       .delay(Double(index) / Double(count) / 2)
               )
               .offset( y: size * scale )
       }
}



 struct AppActivityIndicator: View {
    @State var animate: Bool = false
     let color: Color = .black
     var body: some View {
        BlinkingView(
            animate: $animate,
            count: 3,
            spacing: 8,
            cornerRadius: 8,
            scaleRange: (-0.5...0.5),
            opacityRange:  (0.25...1),
            color: color
        )
        
            .onAppear { animate = true }
            .onDisappear { animate = false }
            .aspectRatio(contentMode: .fit)
    }
 
}
 
