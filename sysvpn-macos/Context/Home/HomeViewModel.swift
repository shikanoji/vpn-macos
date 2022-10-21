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
            @Published var dataServer: [HomeListCountryModel]
            var isConnected: Bool = false
            var listCountry: [HomeListCountryModel]
            var staticServer: [HomeListCountryModel]
            init() {
                dataServer = []
                listCountry = []
                staticServer = []
                getListCountry()
                dataServer = listCountry
            }
            
            func getListCountry() {
                let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
                let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
                let recentCountry = AppDataManager.shared.userCountry?.recentCountries ?? []
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
            
            func onChangeState() {
                
            }
            
            
        
    }
}

extension HomeLeftPanelView {
    @MainActor class HomeLeftPanelViewModel: ObservableObject {
        
        @Published var selectedMenuItem: HomeMenuItem = .none
        var isConnected: Bool = false
        var totalCountry: Int = 0 

        init() {
            let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            totalCountry = availableCountry.count
        }
        
        func onTapConnect() {
            let dj = DependencyContainer.shared 
            DispatchQueue.main.async {
                dj.vpnCore.quickConnect()
            }
            GlobalAppStates.shared.connectedNode =  GlobalAppStates.shared.selectedNode
        }
        
       
        
        
        
    }
} 
