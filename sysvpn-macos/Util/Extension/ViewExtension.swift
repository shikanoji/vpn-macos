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
}
