//
//  MapTooltipView.swift
//  sysvpn-macos
//
//  Created by macbook on 20/10/2022.
//

import Foundation
import SwiftUI
import SwiftUITooltip

public struct ArrowShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addLines([
            CGPoint(x: 0, y: rect.height),
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height),
        ])
        return path
    }
}


struct MapTooltipModifier<TooltipContent: View>: ViewModifier {
    // MARK: - Uninitialised properties
    var enabled: Bool
    var config: TooltipConfig
    var content: TooltipContent
    var name: String = ""

    // MARK: - Initialisers

    init(name: String, enabled: Bool, config: TooltipConfig, @ViewBuilder content: @escaping () -> TooltipContent) {
        self.enabled = enabled
        self.config = config
        self.name = name
        self.content = content()
    }

    // MARK: - Local state

    @State private var contentWidth: CGFloat = 10
    @State private var contentHeight: CGFloat = 10
    
    @State var animationOffset: CGFloat = 0
    @State var animation: Optional<Animation> = nil

    // MARK: - Computed properties

    var showArrow: Bool { config.showArrow   }
    var actualArrowHeight: CGFloat { self.showArrow ? config.arrowHeight : 0 }

    var arrowOffsetX: CGFloat {
        switch config.side {
        case .bottom, .center, .top:
            return 0
        case .left:
            return (contentWidth / 2 + config.arrowHeight / 2)
        case .topLeft, .bottomLeft:
            return (contentWidth / 2
                + config.arrowHeight / 2
                - config.borderRadius / 2
                - config.borderWidth / 2)
        case .right:
            return -(contentWidth / 2 + config.arrowHeight / 2)
        case .topRight, .bottomRight:
            return -(contentWidth / 2
                + config.arrowHeight / 2
                - config.borderRadius / 2
                - config.borderWidth / 2)
        }
    }

    var arrowOffsetY: CGFloat {
        switch config.side {
        case .left, .center, .right:
            return 0
        case .top:
            return (contentHeight / 2 + config.arrowHeight / 2)
        case .topRight, .topLeft:
            return (contentHeight / 2
                + config.arrowHeight / 2
                - config.borderRadius / 2
                - config.borderWidth / 2)
        case .bottom:
            return -(contentHeight / 2 + config.arrowHeight / 2)
        case .bottomLeft, .bottomRight:
            return -(contentHeight / 2
                + config.arrowHeight / 2
                - config.borderRadius / 2
                - config.borderWidth / 2)
        }
    }

    // MARK: - Helper functions

    private func offsetHorizontal(_ g: GeometryProxy) -> CGFloat {
        switch config.side {
        case .left, .topLeft, .bottomLeft:
            return -(contentWidth + config.margin + actualArrowHeight + animationOffset)
        case .right, .topRight, .bottomRight:
            return g.size.width + config.margin + actualArrowHeight + animationOffset
        case .top, .center, .bottom:
            return (g.size.width - contentWidth) / 2
        }
    }

    private func offsetVertical(_ g: GeometryProxy) -> CGFloat {
        switch config.side {
        case .top, .topRight, .topLeft:
            return -(contentHeight + config.margin + actualArrowHeight + animationOffset)
        case .bottom, .bottomLeft, .bottomRight:
            return g.size.height + config.margin + actualArrowHeight + animationOffset
        case .left, .center, .right:
            return (g.size.height - contentHeight) / 2
        }
    }
    
    // MARK: - Animation stuff
    
    private func dispatchAnimation() {
        if (config.enableAnimation) {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.animationTime) {
                withAnimation {
                    self.animationOffset = config.animationOffset
                    self.animation = config.animation
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + config.animationTime*0.1) {
                    withAnimation {
                        self.animationOffset = 0
                    }
                    
                    self.dispatchAnimation()
                }
            }
        }
    }

    // MARK: - TooltipModifier Body Properties

    private var sizeMeasurer: some View {
        GeometryReader { g in
            Text("")
                .onAppear {
                    self.contentWidth = config.width ?? g.size.width
                    self.contentHeight = config.height ?? g.size.height
                }.onChange(of: name) { newValue in
                    self.contentWidth = config.width ?? g.size.width
                    self.contentHeight = config.height ?? g.size.height
                }
                 
        }
    }

    private var arrowView: some View {
        
        let arrowAngle: Double = 0
        return AnyView(ArrowShape()
            .rotation(Angle(radians: arrowAngle))
            .stroke(config.borderColor)
            .background(ArrowShape()
                .offset(x: 0, y: 1)
                .rotation(Angle(radians: arrowAngle))
                .frame(width: config.arrowWidth+2, height: config.arrowHeight+1)
                .foregroundColor(config.backgroundColor)
                
            ).frame(width: config.arrowWidth, height: config.arrowHeight)
            .offset(x: self.arrowOffsetX, y: self.arrowOffsetY))
    }

    private var arrowCutoutMask: some View {
        let arrowAngle: Double =  0
        return AnyView(
            ZStack {
                Rectangle()
                    .frame(
                        width: self.contentWidth + config.borderWidth * 2,
                        height: self.contentHeight + config.borderWidth * 2)
                    .foregroundColor(.white)
                Rectangle()
                    .frame(
                        width: config.arrowWidth,
                        height: config.arrowHeight + config.borderWidth)
                    .rotationEffect(Angle(radians: arrowAngle))
                    .offset(
                        x: self.arrowOffsetX,
                        y: self.arrowOffsetY)
                    .foregroundColor(.black)
            }
            .compositingGroup()
            .luminanceToAlpha()
        )
    }

    var tooltipBody: some View {
        GeometryReader { g in
            ZStack {
                RoundedRectangle(cornerRadius: config.borderRadius)
                    .stroke(config.borderWidth == 0 ? Color.clear : config.borderColor)
                    .frame(
                        minWidth: contentWidth,
                        idealWidth: contentWidth,
                        maxWidth: config.width,
                        minHeight: contentHeight,
                        idealHeight: contentHeight,
                        maxHeight: config.height
                    )
                    .background(
                        RoundedRectangle(cornerRadius: config.borderRadius)
                            .foregroundColor(config.backgroundColor)
                    )
                    .mask(self.arrowCutoutMask)
                
                ZStack {
                    content
                        .padding(config.contentPaddingEdgeInsets)
                        .frame(
                            width: config.width,
                            height: config.height
                        )
                        .fixedSize(horizontal: config.width == nil, vertical: true)
                }
                .background(self.sizeMeasurer)
                .overlay(self.arrowView)
            }
            .offset(x: self.offsetHorizontal(g), y: self.offsetVertical(g))
            //.animation(self.animation)
            .zIndex(config.zIndex)
            .onAppear {
                self.dispatchAnimation()
            }
        }
    }

    // MARK: - ViewModifier properties

    func body(content: Content) -> some View {
        content
            .overlay(enabled ? tooltipBody.transition(config.transition) : nil)
    }
}
