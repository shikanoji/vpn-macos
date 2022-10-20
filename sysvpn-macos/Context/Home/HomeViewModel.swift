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
        @Published var listCountry: [HomeListCountryModel]
        var isConnected: Bool = false

        init() {
            listCountry = []
            let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
            let recentCountry = AppDataManager.shared.userCountry?.recentCountries ?? []
            print("[availableCountry]: \(availableCountry)")
            print("[recommendCountry]: \(recommendCountry)")
            print("[recentCountry]: \(recentCountry)") 
            print("[LENGTH]: \(recentCountry.count): \(recommendCountry.count): \(availableCountry.count)")
            if recentCountry.count  > 0 {
                listCountry.append(HomeListCountryModel(type: .header, title: "Recent locations"))
                for item in recentCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
            
            if recommendCountry.count  > 0 {
                listCountry.append(HomeListCountryModel(type: .header, title: "Recommended"))
                for item in recommendCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
            
            if availableCountry.count  > 0 {
                listCountry.append(HomeListCountryModel(type: .header, title: "All countries"))
                for item in availableCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
            
        }
        
    }
}

extension HomeLeftPanelView {
    @MainActor class HomeLeftPanelViewModel: ObservableObject {
        
        @Published var selectedMenuItem: HomeMenuItem = .none
        var isConnected: Bool = false

        init() {
            
        }
        
        func onTapConnect() {
            let dj = DependencyContainer.shared 
            DispatchQueue.main.async {
                dj.vpnManager.whenReady(queue: DispatchQueue.main) {
                    dj.vpnCore.quickConnect()
                }
            }
        }
        
    }
} 
