//
//  HomeZoomSliderView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI
struct HomeZoomTrack : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stepSize = (rect.width - 4) / 4
        for i in 0...4 {
            path.addRect(CGRect(x: CGFloat(i) * stepSize , y: 0, width: 2, height: rect.height))
            
        }
        return path
    }
    
    
}
struct HomeZoomSliderView: View {
    @Binding var value: Double
    var step: Double = 5
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...100
    
    var thumbColor: Color = .init(rgb: 0x9697A6)
    var minTrackColor: Color = .init(rgb: 0x31323B)
    var maxTrackColor: Color = .init(rgb: 0x31323B)
    let height: CGFloat = 10
    var body: some View {
        HStack {
            Asset.Assets.icDecZoom.swiftUIImage
                .onTapGesture {
                    value = max(sliderRange.lowerBound, value - step)
                }
            GeometryReader { gr in
                let thumbHeight: CGFloat =  height
                let thumbWidth: CGFloat = 2
                let radius = gr.size.height * 0.5
                let minValue = gr.size.width * 0.015
                let maxValue = (gr.size.width * 0.98) - thumbWidth
                
                let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                let lower = sliderRange.lowerBound
                let sliderVal = max(0, (self.value - lower) * scaleFactor + minValue)
                
                ZStack {
                    /*Rectangle()
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
                     */
                    HomeZoomTrack().fill(maxTrackColor)
                    HStack {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(thumbColor)
                            .frame(width: thumbWidth, height: thumbHeight)
                            .offset(x: sliderVal)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { v in
                                        if abs(v.translation.width) < 0.1 {
                                            self.lastCoordinateValue = sliderVal
                                        }
                                        if v.translation.width > 0 {
                                            let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                            self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                        } else {
                                            let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                            self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                        }
                                    }
                            )
                        Spacer()
                    }
                }
            }.frame(height: height)
            Asset.Assets.icIncZoom.swiftUIImage
                .onTapGesture {
                    value = min(sliderRange.upperBound, value + step)
            }
        }
        .padding(4)
        .background(Color.black)
        .cornerRadius(40)
        
    }
}

struct HomeZoomSliderView_Previews: PreviewProvider {
    @State static var value: Double = 30
    static var previews: some View {
        HomeZoomSliderView(value: $value)
    }
}
