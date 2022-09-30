//
//  WindowMgr.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI

enum OpenWindows: String, CaseIterable {
    case LoginView
    case MainView
   
    func open() {
        if let url = URL(string: "sysvpn://\(rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
}
