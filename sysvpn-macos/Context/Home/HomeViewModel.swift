//
//  HomeModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Combine
import Foundation

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        @Published var selectedMenuItem: HomeMenuItem = .none
        @Published var listCity: [HomeListCountryModel]
        @Published var countrySelected: HomeListCountryModel?
        @Published var lookScrollZoom = false
        @Published var isOpenSetting = false

        var cancellabel: AnyCancellable?

        var isConnected: Bool = false
        var listCountry: [HomeListCountryModel]
        var listStaticServer: [HomeListCountryModel]
        var listMultiHop: [HomeListCountryModel]
        init() {
            listCountry = []
            listStaticServer = []
            listMultiHop = []
            listCity = []
            getListCountry()
            getListStaticServer()
            getListMultiHop()
            _ = GlobalAppStates.shared.initApp {
                print("init app success")
            }
            
            cancellabel = Publishers.CombineLatest($selectedMenuItem, $isOpenSetting).receive(on: RunLoop.main).map {
                return $0.0 != .none || $0.1
            }.eraseToAnyPublisher().assign(to: \HomeViewModel.lookScrollZoom, on: self) as AnyCancellable
        }
        
        func onViewAppear() {}
            
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
                let itemCityModel = HomeListCountryModel(type: .country, title: dataCity.name ?? "", origin: dataCity)
                listCity.append(itemCityModel)
            }
        }
            
        func updateAvailableContry() {
            let availableCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            let recommendCountry = AppDataManager.shared.userCountry?.recommendedCountries ?? []
            let recentCountry = AppDataManager.shared.userCountry?.recentCountries ?? []
                
            if !recentCountry.isEmpty {
                listCountry.append(HomeListCountryModel(type: .header, title: "Recent locations"))
                for item in recentCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0, origin: item)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
                
            if !recommendCountry.isEmpty {
                listCountry.append(HomeListCountryModel(type: .header, title: "Recommended"))
                for item in recommendCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0, origin: item)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
            if !availableCountry.isEmpty {
                listCountry.append(HomeListCountryModel(type: .header, title: "All countries"))
                for item in availableCountry {
                    let countryItemModel = HomeListCountryModel(type: .country, title: item.name ?? "", totalCity: item.city?.count ?? 0, imageUrl: item.flag, idCountry: item.id ?? 0, origin: item)
                    listCountry.append(countryItemModel)
                }
                listCountry.append(HomeListCountryModel(type: .spacing))
            }
        }
            
        func getListStaticServer(firstLoadData: Bool = true) {
            listStaticServer.removeAll()
            let staticServer = AppDataManager.shared.userCountry?.staticServers ?? []
            if !staticServer.isEmpty {
                listStaticServer.append(HomeListCountryModel(type: .header, title: "Static ip"))
                for item in staticServer {
                    let score = item.score ?? 1
                    let staticItem = HomeListCountryModel(type: .country, title: item.countryName ?? "", imageUrl: item.flag, cityName: item.cityName ?? "", serverNumber: item.serverNumber ?? 1, serverStar: score + 1, origin: item)
                    listStaticServer.append(staticItem)
                }
                listStaticServer.append(HomeListCountryModel(type: .spacing))
            }
        }
            
        func getListMultiHop() {
            let multiHopServer = AppDataManager.shared.mutilHopServer ?? []
            if !multiHopServer.isEmpty {
                listMultiHop.append(HomeListCountryModel(type: .header, title: "MultiHop"))
                for item in multiHopServer {
                    let multiHopItem = HomeListCountryModel(type: .country, title: item.entry?.country?.name ?? "", imageUrl: item.entry?.country?.flag, title2: item.exit?.country?.name ?? "", imageUrl2: item.exit?.country?.flag, origin: item)
                    listMultiHop.append(multiHopItem)
                }
            }
        }
            
        func onChangeState() {
            if selectedMenuItem == .manualConnection {
                if listCountry.isEmpty {
                    updateAvailableContry()
                }
            }
        }
            
        func connect(to info: INodeInfo? = nil) {
            MapAppStates.shared.connectedNode = nil
            let dj = DependencyContainer.shared
            if let city = info as? CountryCity {
                dj.vpnCore.connect(with: .init(connectType: .cityId(id: city.id ?? 0)))
            } else if let country = info as? CountryAvailables {
                dj.vpnCore.connect(with: .init(connectType: .countryId(id: country.id ?? 0)))
            } else if let staticServer = info as? CountryStaticServers {
                dj.vpnCore.connectTo(connectType: .serverId(id: staticServer.serverId ?? 0), params: nil)
            } else if let multiplehop = info as? MultiHopResult {
                dj.vpnCore.connect(with: .init(connectType: .serverId(id: multiplehop.entry?.serverId ?? 0), params: SysVPNConnectParams(isHop: true)))
                multiplehop.entry?.city?.country = multiplehop.entry?.country
                multiplehop.exit?.city?.country = multiplehop.exit?.country
                MapAppStates.shared.connectedNode = multiplehop
            }
        }
    }
}

extension HomeLeftPanelView {
    @MainActor class HomeLeftPanelViewModel: ObservableObject {
        @Published var selectedMenuItem: HomeMenuItem = .none
        @Published var totalCountry: Int = 0
        @Published var totalMultipleHop: Int = 0
        var isConnected: Bool = false
        
        init() {
            onUpdateServer()
            onUpdateMultipleHop()
            NotificationCenter.default.addObserver(self, selector: #selector(onUpdateServer), name: .updateCountry, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(onUpdateMultipleHop), name: .updateMultipleHop, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: .updateCountry, object: nil)
            NotificationCenter.default.removeObserver(self, name: .updateMultipleHop, object: nil)
        }
        
        @objc func onUpdateServer() {
            AppDataManager.shared.asyncLoadConfig {
                return AppDataManager.shared.userCountry?.availableCountries ?? []
            } completion: { availableCountry in
                self.totalCountry = availableCountry.count
            }
        }
        
        @objc func onUpdateMultipleHop() {
            AppDataManager.shared.asyncLoadConfig {
                return AppDataManager.shared.mutilHopServer ?? []
            } completion: { availableCountry in
                self.totalMultipleHop = availableCountry.count
            }
        }
        
        func onTapConnect() {
            if GlobalAppStates.shared.displayState == .disconnected {
                MapAppStates.shared.connectedNode = nil
                let dj = DependencyContainer.shared
                if let selectedNode = MapAppStates.shared.selectedNode {
                    if let city = selectedNode as? CountryCity {
                        dj.vpnCore.connect(with: .init(connectType: .cityId(id: city.id ?? 0)))
                    } else if let country = selectedNode as? CountryAvailables {
                        dj.vpnCore.connect(with: .init(connectType: .countryId(id: country.id ?? 0)))
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
