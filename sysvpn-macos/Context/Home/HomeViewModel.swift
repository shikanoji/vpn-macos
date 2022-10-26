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
            @Published var listCity: [HomeListCountryModel]
            @Published var countrySelected: HomeListCountryModel?
            var isConnected: Bool = false
            var listCountry: [HomeListCountryModel]
            var listStaticServer: [HomeListCountryModel]
            init() {
                dataServer = []
                listCountry = []
                listStaticServer = []
                listCity = []
                getListCountry()
                getListStaticServer()
                dataServer = listCountry
            }
            
            func getListCountry() {
                updateAvailableContry() 
            }
             
            func onChangeCountry(item: HomeListCountryModel?) {
                listCity = []
                let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
                let countryData = availableCountry.filter { data in
                    return data.id == (item?.idCountry ?? 0)
                }.first
                let arrCity = countryData?.city ?? []
                
                for dataCity in arrCity {
                    let itemCityModel = HomeListCountryModel(type: .country, title: dataCity.name ?? "")
                    listCity.append(itemCityModel)
                }
            }
            
            func updateAvailableContry() {
                listCountry = []
                let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
                let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
                let recentCountry = AppDataManager.shared.userCountry?.recentCountries ?? []
                
                if recentCountry.count  > 0 {
                    listCountry.append(HomeListCountryModel(type: .header, title: "Recent locations"))
                    for item in recentCountry {
                        let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0)
                        listCountry.append(countryItemModel)
                    }
                    listCountry.append(HomeListCountryModel(type: .spacing))
                }
                
                if recommendCountry.count  > 0 {
                    listCountry.append(HomeListCountryModel(type: .header, title: "Recommended"))
                    for item in recommendCountry {
                        let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0)
                        listCountry.append(countryItemModel)
                    }
                    listCountry.append(HomeListCountryModel(type: .spacing))
                }
                if availableCountry.count  > 0 {
                    listCountry.append(HomeListCountryModel(type: .header, title: "All countries"))
                    for item in availableCountry {
                        let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0)
                        listCountry.append(countryItemModel)
                    }
                    listCountry.append(HomeListCountryModel(type: .spacing))
                }
            }
            
            func getListStaticServer(firstLoadData: Bool = true) {
                listStaticServer.removeAll()
                let staticServer = AppDataManager.shared.userCountry?.staticServers ?? []
                if staticServer.count  > 0 {
                    listStaticServer.append(HomeListCountryModel(type: .header, title: "Static ip"))
                    for item in staticServer {
                        let score = item.score ?? 1 
                        let staticItem = HomeListCountryModel(type: .country, title: item.countryName ?? "", imageUrl: item.flag, cityName: item.cityName ?? "", serverNumber: item.serverNumber ?? 1, serverStar: score + 1)
                        listStaticServer.append(staticItem)
                    }
                    listStaticServer.append(HomeListCountryModel(type: .spacing))
                }
                if !firstLoadData {
                    dataServer = listStaticServer
                }
            }
            
            func getListMultiHop() {
                
            }
            
            func onChangeState() {
                print("selectedMenuItem: \(selectedMenuItem)")
                if selectedMenuItem == .staticIp {
                    dataServer = listStaticServer
                } else if selectedMenuItem == .manualConnection {
                    dataServer = listCountry
                    if listCountry.isEmpty {
                        updateAvailableContry()
                        dataServer = listCountry
                    }
                } else if selectedMenuItem == .multiHop {
                    
                }
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
            if GlobalAppStates.shared.displayState == .disconnected {
                let dj = DependencyContainer.shared
                if let selectedNode = GlobalAppStates.shared.selectedNode {
                    if let city  = selectedNode as? CountryCity {
                        dj.vpnCore.connect(with: .init(connectType: .cityId(id: city.id ?? 0)))
                    } else if let country = selectedNode as? CountryAvailables {
                        dj.vpnCore.connect(with: .init(connectType: .countryId(id: country.id ?? 0 )))
                    } else {
                        dj.vpnCore.quickConnect()
                    }
                  
                } else {
                    dj.vpnCore.quickConnect()
                }
            } else {
                if GlobalAppStates.shared.displayState == .disconnecting {
                    return
                }
                DependencyContainer.shared.vpnCore.disconnect()
            }
            
        }
        
       
        
        
        
    }
} 
