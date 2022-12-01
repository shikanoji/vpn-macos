//
//  ProfileSelectLocationViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 29/11/2022.
//

import Foundation

extension ProfileSelectLocationView {
    @MainActor class ProfileSelectLocationViewModel: ObservableObject {
        @Published var listCountry: [CountryAvailables]
        
        init() {
            listCountry = []
            getListCountry()
        }
        
        
        func getListCountry() {
            listCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
        }
    }
}
