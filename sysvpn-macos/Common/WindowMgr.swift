//
//  WindowMgr.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI

enum OpenWindows: String, CaseIterable {
    case LoginView = "LoginView"
    case MainView   = "MainView"
   
    func open(){
        if let url = URL(string: "sysvpn://\(self.rawValue)") { 
            NSWorkspace.shared.open(url)
        }
    }
}
