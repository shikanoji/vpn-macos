//
//  HomeZoomSliderView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI

struct HomeZoomSliderView : View {
    @Binding var value: Double
        
        @State var lastCoordinateValue: CGFloat = 0.0
        var sliderRange: ClosedRange<Double> = 1...100
        var thumbColor: Color = .yellow
        var minTrackColor: Color = .blue
        var maxTrackColor: Color = .gray
        
        var body: some View {
            GeometryReader { gr in
                let thumbHeight = gr.size.height * 1.1
                let thumbWidth = gr.size.width * 0.03
                let radius = gr.size.height * 0.5
                let minValue = gr.size.width * 0.015
                let maxValue = (gr.size.width * 0.98) - thumbWidth
                
                let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                let lower = sliderRange.lowerBound
                let sliderVal = (self.value - lower) * scaleFactor + minValue
                
                ZStack {
                    Rectangle()
                        .foregroundColor(maxTrackColor)
                        .frame(width: gr.size.width, height: 3)
                        .clipShape(RoundedRectangle(cornerRadius: radius))
                    HStack {
                        Rectangle()
                            .foregroundColor(minTrackColor)
                        .frame(width: sliderVal, height: 3)
                        Spacer()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    HStack {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(thumbColor)
                            .frame(width: thumbWidth, height: thumbHeight)
                            .offset(x: sliderVal)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { v in
                                        if (abs(v.translation.width) < 0.1) {
                                            self.lastCoordinateValue = sliderVal
                                        }
                                        if v.translation.width > 0 {
                                            let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                            self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                        } else {
                                            let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                            self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                        }
                                   }
                            )
                        Spacer()
                    }
                }
            }
        }
}


struct HomeZoomSliderView_Previews: PreviewProvider {
    @State static var  value: Double = 30
    static var previews: some View {
        HomeZoomSliderView(value: $value)
    }
}
