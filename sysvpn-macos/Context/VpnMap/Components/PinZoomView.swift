//
//  PinZoomView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI
 
struct ZoomModifier: ViewModifier {
    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 3.0
    private var numberImage: CGFloat = 3
    
    
    @State var currentScale: CGFloat = 1.0
    @State var isDrag = false
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero

    init(contentSize: CGSize) {
        self.contentSize = contentSize
    }
    
    func calcOffset(newOffset: CGSize, skipCheckPosition: Bool = false) {
        let newContentWidth = contentSize.width * currentScale * numberImage
        let newContentHeight = contentSize.height * currentScale
        
        if offset.height > 0 {
            offset.height = 0
        }
        if !skipCheckPosition {
            if abs(offset.width) > newContentWidth * 2 / numberImage || abs(offset.width) < newContentWidth / numberImage {
                offset.width = offset.width.remainder(dividingBy: newContentWidth / numberImage) - newContentWidth / numberImage
            }
        }
     
        if offset.height * -1 > newContentHeight - contentSize.height {
            offset.height = (newContentHeight - contentSize.height) * -1
        }
    }
    
    func onScaleCalcOffset(value: CGFloat) {
        let currentWidth = contentSize.width * numberImage * currentScale
        let currentHeight = contentSize.height * currentScale
        let nextWith = contentSize.width * value * numberImage
        let nextHeight = contentSize.height * value
        offset.width += (currentWidth - nextWith) / 2
        offset.height += (currentHeight - nextHeight) / 2
        calcOffset(newOffset: offset, skipCheckPosition: currentScale > 0.9)
    }
     
    func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            content
                .frame(width: contentSize.width * currentScale * numberImage, height: contentSize.height * currentScale, alignment: .center)
                .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale, onScale: onScaleCalcOffset))
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                
                    .onChanged { val in
                        if isDrag == false {
                            lastOffset = offset
                        }
                        isDrag = true
                        offset.width = lastOffset.width + val.translation.width
                        offset.height = lastOffset.height + val.translation.height
                        calcOffset(newOffset: offset)
                    }
                    .onEnded { _ in
                        isDrag = false
                    }
                )
                
        }.content.offset(offset)
            .onAppear {
                offset.width = contentSize.width * -1
            }
    }
}

struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    // var mouseLocation: NSPoint { NSEvent.mouseLocation }
    
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @State var isPinching: Bool = false
    @GestureState var magnifyBy = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    let onScale: (CGFloat) -> Void

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, _ in
                gestureState = currentState
            }.onChanged { val in
                let delta = val / lastScaleValue
                self.lastScaleValue = val
                var newScale = scale * delta
                if newScale > maxScale {
                    newScale = maxScale
                } else if newScale < minScale {
                    newScale = minScale
                }
                self.onScale(newScale)
                scale = newScale
                isPinching = true
            }.onEnded { _ in
                isPinching = false
                lastScaleValue = 1.0
            }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .gesture(magnification)
    }
}
