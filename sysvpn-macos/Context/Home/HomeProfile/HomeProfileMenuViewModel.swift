//
//  HomeProfileMenuViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/11/2022.
//

import Foundation

extension HomeProfileMenuView {
    
    @MainActor class HomeProfileMenuViewModel: ObservableObject { 
        @Published var test = [1,2,3]
        
        init() {
        }
        
        func onCreateProfile() {
            
        }
    }
    
}



