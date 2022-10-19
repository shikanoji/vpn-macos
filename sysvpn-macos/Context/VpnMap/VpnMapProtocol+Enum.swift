//
//  VpnMapViewProtocol.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 29/09/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip
import Kingfisher

protocol INodeInfo {
    var state: VpnMapPontState { get }
    var localtionIndex: Int? { get }
    var locationName: String { get }
    var image: KFImage? { get }
}

struct NodePoint {
    var point: CGPoint
    var info: INodeInfo
    init(point: CGPoint, info: INodeInfo) {
        self.point = point
        self.info = info
    }
}

struct ConnectPoint {
    var point1: CGPoint
    var point2: CGPoint
    
    func buildPath(scale: CGFloat) -> Path {
        let point1 = CGPoint(x: self.point1.x * scale, y: self.point1.y * scale)
        let point2 = CGPoint(x: self.point2.x * scale, y: self.point2.y * scale)
        
        var line = Path()
        line.move(to: point1)
        let vec = CGPoint(x: point2.x - point1.x, y: point2.y - point1.y)
        let direction = min(1, (point2.x - point1.x) / abs(point2.x - point1.x))
        var y2: CGFloat = vec.x / vec.y
        var x2: CGFloat = 2
        if vec.y == 0 {
            y2 = -2
        }
        if vec.x == 0 {
            x2 = -2
            y2 = -2
        }
        let length2 = sqrt(y2 * y2 + x2 * x2)
        let length = sqrt(vec.x * vec.x + vec.y * vec.y) * 0.5 * direction
        let vec2 = CGPoint(x: x2 / length2 * length, y: y2 / length2 * length)
        line.addQuadCurve(to: point2, control: CGPoint(x: point1.x + vec2.x, y: point1.y + vec2.y))
        
        return line
    }
}

class NodeInfoTest: INodeInfo {
    var image: KFImage? {
        return nil
    }
    
    var localtionIndex: Int?
    var state: VpnMapPontState = .disabled
    var locationName: String = "TEST NODE"
    
    init(state: VpnMapPontState, localtionIndex: Int? = nil) {
        self.state = state
        self.localtionIndex = localtionIndex
    }
}

enum VpnMapPontState {
    case normal
    case disabled
    case activated
    case activeDisabled
    
    var icon: Image {
        switch self {
        case .normal:
            return Asset.Assets.icNode.swiftUIImage
        case .activated:
            return Asset.Assets.icNodeActive.swiftUIImage
        case .disabled:
            return Asset.Assets.icNodeDisabled.swiftUIImage
        case .activeDisabled:
            return Asset.Assets.icNodeActiveDisabled.swiftUIImage
        }
    }
}

public struct AppTooltipConfig: TooltipConfig {
    static var shared = DefaultTooltipConfig()

    public var side: TooltipSide = .bottom
    public var margin: CGFloat = 8
    public var zIndex: Double = 10000
    
    public var width: CGFloat?
    public var height: CGFloat?

    public var borderRadius: CGFloat = 8
    public var borderWidth: CGFloat = 2
    public var borderColor: Color = .primary
    public var backgroundColor: Color = .white

    public var contentPaddingLeft: CGFloat = 12
    public var contentPaddingRight: CGFloat = 12
    public var contentPaddingTop: CGFloat = 8
    public var contentPaddingBottom: CGFloat = 8

    public var contentPaddingEdgeInsets: EdgeInsets {
        EdgeInsets(
            top: contentPaddingTop,
            leading: contentPaddingLeft,
            bottom: contentPaddingBottom,
            trailing: contentPaddingRight
        )
    }

    public var showArrow: Bool = true
    public var arrowWidth: CGFloat = 12
    public var arrowHeight: CGFloat = 6
    
    public var enableAnimation: Bool = false
    public var animationOffset: CGFloat = 10
    public var animationTime: Double = 1
    public var animation: Animation? = .easeInOut

    public var transition: AnyTransition = .opacity

    public init() {}

    public init(side: TooltipSide) {
        self.side = side
    }
}
