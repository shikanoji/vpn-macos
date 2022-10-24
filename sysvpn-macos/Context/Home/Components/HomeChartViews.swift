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
            if yValues.isEmpty {
                return path
            }
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
    var height: CGFloat = 54
    var body: some View{
        return TimelineView(.animation) { timeLine in
            let list = DependencyContainer.shared.appStateMgr.statistics?.uploadHistory.lastNItems() ?? []
            let list2 = DependencyContainer.shared.appStateMgr.statistics?.downloadHistory.lastNItems() ?? []
            
            let maxValue = max(list.max() ?? 1, list2.max() ?? 1)
            
            ZStack {
                ChartLineBackground().stroke(Color.white.opacity(0.05), lineWidth: 1.0)
                LineShape(yValues: list, scaleFactor: height / max(2, maxValue) ).stroke(Color(rgb: 0x464859), lineWidth: 1.0)
                LineShape(yValues: list2 , scaleFactor: height / max(2, maxValue) ).stroke(Asset.Colors.primaryColor.swiftUIColor, lineWidth: 1.0)
                
            }.frame( height: height)
                .padding(.top, 5)
                .padding(.bottom, 5)
          
            HStack(  alignment: .top) {
                Spacer()
                Text(Bitrate.rateString(for: UInt32(maxValue)))
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .transformEffect(.init(translationX: 0, y: -42))
            }.frame( height: height)
        }
    }
    
    
}
 
