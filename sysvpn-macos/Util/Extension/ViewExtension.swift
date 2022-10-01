//
//  ViewExtension.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI

extension View {
    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackinAreaView(onMove: onMove) { self }
    }
    
    func expandTap(tap: @escaping () -> ()) -> some View {
        self.modifier(ExpandAreaTap()).onTapGesture(perform: tap)
    }
}

private struct ExpandAreaTap: ViewModifier {
    func body(content: Content) -> some View {
        content.contentShape(Rectangle())
    }
}

 
