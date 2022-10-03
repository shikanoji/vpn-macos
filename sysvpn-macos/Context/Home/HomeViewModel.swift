//
//  HomeModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation

extension HomeView {
        @MainActor class HomeViewModel: ObservableObject {
        @Published var selectedMenuItem: HomeMenuItem = .none
            
        var isConnected: Bool = false

        init() {
            
        }
        
    }
}
