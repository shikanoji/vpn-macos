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
        let size:CGFloat
        let cornerRadius: CGFloat
        let scaleRange: ClosedRange<Double>
        let opacityRange: ClosedRange<Double>
        let color: Color

        init(animate: Binding<Bool>,
                   count: UInt = 8,
                   spacing: CGFloat = 8,
                   size: CGFloat = 10,
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
           self.size = size
       }

        var body: some View {
           HStack (spacing: spacing){
               ForEach(0..<Int(count)) { index in
                   item(forIndex: index)
               }
           }.frame(width: CGFloat(count) * size + CGFloat(count - 1) * spacing, height: size + 5)
       }

       private var scale: CGFloat { CGFloat(isAnimating ? scaleRange.lowerBound : scaleRange.upperBound) }
       private var opacity: Double { isAnimating ? opacityRange.lowerBound : opacityRange.upperBound }

      
       private func item(forIndex index: Int) -> some View {
           RoundedRectangle(cornerRadius: cornerRadius,  style: .continuous)
               .frame(width: size, height: size)
               .opacity(opacity)
               .foregroundColor(color)
               .animation(
                   Animation
                       .default
                       .repeatCount(isAnimating ? .max : 1, autoreverses: true)
                       .delay(Double(index) / Double(count) / 2),
                   value: isAnimating
               )
               .offset( y: size * scale )
       }
}



 struct AppActivityIndicator: View {
    @State var animate: Bool = false
     var color: Color = .black
     var body: some View {
        BlinkingView(
            animate: $animate,
            count: 3,
            spacing: 4,
            size: 10,
            cornerRadius: 6,
            scaleRange: (-0.5...0.5),
            opacityRange:  (1...1),
            color: color
        ) 
            .onAppear { animate = true }
            .onDisappear { animate = false }
            .aspectRatio(contentMode: .fit)
    }
 
}
 
struct AppActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        AppActivityIndicator(color: Color.black)
    }
}

