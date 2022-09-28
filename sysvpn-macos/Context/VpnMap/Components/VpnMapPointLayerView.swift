//
//  VpnMapPointLayerView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI

import SwiftUITooltip

struct ConnectPoint {
    var point1: CGPoint
    var point2: CGPoint
    
    func buildPath() -> Path {
        var line = Path()
        line.move(to: point1)
        let vec = CGPoint(x: point2.x - point1.x,y: point2.y - point1.y)
        let direction = min(1, (point2.x - point1.x) / abs(point2.x - point1.x))
        var y2: CGFloat =  vec.x / vec.y
        var x2: CGFloat = 1
        if (vec.y == 0) {
            y2 = -1
        }
        if (vec.x == 0) {
            x2 = -1
            y2 = -1
        }
        let length2 = sqrt(y2*y2 + x2 * x2);
        let length = sqrt(vec.x * vec.x + vec.y * vec.y) *  0.5 * direction
        let vec2 = CGPoint(x: x2 / length2 * length, y: y2 / length2 * length)
        line.addQuadCurve(to: point2, control: CGPoint(x:  point1.x + vec2.x, y: point1.y + vec2.y))
        
        return line;
    }
}

struct VpnMapPointLayerView : View {
    var connectPoints: [ConnectPoint] = [
        ConnectPoint(point1: CGPoint(x: 100, y: 300), point2: CGPoint(x: 200,y: 100))]
    let lineGradient = Gradient(colors: [
        Asset.Colors.secondary.swiftUIColor
        , Asset.Colors.primaryColor.swiftUIColor
    ])
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Canvas {  context, size in
                connectPoints.forEach { point in
                    context.stroke(point.buildPath(), with: .linearGradient(lineGradient, startPoint: point.point1, endPoint: point.point2))
                }
            }
            VpnMapPointView(state: .activeDisabled).position(x: 100, y: 300)
            VpnMapPointView().position(x: 200, y: 100).tooltip(true) {
                Text("I'm the text explaining the confusing text.")
            }
        }
    }
}


struct VpnMapPointLayerView_Previews: PreviewProvider {
    static var previews: some View {
        VpnMapPointLayerView()
    }
}
