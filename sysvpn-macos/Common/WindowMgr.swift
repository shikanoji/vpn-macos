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
    case SpashView
    
    func open() {
        /* if let url = URL(string: "sysvpn://\(rawValue)") {
             NSWorkspace.shared.open(url)
         }*/
        WindowMgr.shared.currentWindow = self
    }
}

class WindowMgr: ObservableObject {
    private static var _instance: WindowMgr = .init()
    
    static var shared: WindowMgr {
        return _instance
    }
    
    @Published var currentWindow: OpenWindows = .SpashView
}
