//
//  GlobalAppState.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation


class GlobalAppStates: ObservableObject {
    static let shared = GlobalAppStates()
    
    @Published var isConnected: Bool = false
    
}
