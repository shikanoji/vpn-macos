//
//  HomeChartViews.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI

struct LineShape: Shape {
    var yValues: [Double]
        var scaleFactor: Double
        
        func path(in rect: CGRect) -> Path {
            let xIncrement = (rect.width / (CGFloat(yValues.count)))
            var xValue = xIncrement * 0.5
            var path = Path()
            path.move(to: CGPoint(x: xValue,
                                  y: (rect.height - (yValues[0] * scaleFactor))))
            for i in 1..<yValues.count {
                xValue += xIncrement
                let pt = CGPoint(x: xValue,
                                 y: (rect.height - (yValues[i] * scaleFactor)))
                path.addLine(to: pt)
            }
            return path
        }
}
struct ChartLineBackground: Shape {
    
        
        func path(in rect: CGRect) -> Path {
            let spacing: CGFloat = rect.height / 3
            var path = Path()
           
            for i in 0..<4 {
               /* xValue += xIncrement
                let pt = CGPoint(x: xValue,
                                 y: (rect.height - (yValues[i] * scaleFactor)))
                path.addLine(to: pt)*/
                let floatI = CGFloat(i)
                path.move(to: CGPoint(x: 0,
                                      y: rect.height - floatI * spacing))
                          
                path.addLine(to: CGPoint(x: rect.width, y: rect.height - floatI * spacing))
            }
            
            return path
        }
}

struct TrafficLineChartView : View {
    var list : [Double] =  [164, 182, 212, 198, 242, 30, 158, 6, 67, 195, 104, 125, 125, 92, 81, 188, 50, 155, 225, 243, 53, 141, 32, 1];
    var list2 : [Double] =  [1, 2, 212, 242, 92, 81, 188, 50, 155, 243, 243, 53, 141, 32, 1, 242, 30, 158, 6, 188, 195, 104, 67, 125 ];
    var height: CGFloat = 54
    var body: some View{
        return ZStack {
            ChartLineBackground().stroke(Color.white.opacity(0.05), lineWidth: 1.0)
            LineShape(yValues: list2, scaleFactor: height / max(1,(list.max() ?? 1)) ).stroke(Color(rgb: 0x464859), lineWidth: 1.0)
            LineShape(yValues: list, scaleFactor: height / max(1,(list.max() ?? 1)) ).stroke(Asset.Colors.primaryColor.swiftUIColor, lineWidth: 1.0)
        }.frame( height: height)
    }
}
