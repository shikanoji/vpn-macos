//
//  VpnMapViewModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 03/09/2022.
//

import Foundation
import SwiftUI
import Kingfisher


extension VpnMapView {
    @MainActor class VpnMapViewModel: ObservableObject {
        
        @Published var listCity: [NodePoint] = []
        @Published var listCountry: [NodePoint] = []
        
        
        func convertX(_ value: Double? , scale: Double = 1) -> CGFloat {
            return (value ?? 0) * 0.5
        }
        
        func convertY(_ value: Double? , scale: Double = 1) -> CGFloat {
            return (value ?? 0) * 0.453
        }
         
        init() {
            _ = APIServiceManager.shared.getListCountry().subscribe { event in
                switch event {
                case .failure(let error):
                    print(error)
                case .success(let success):
                    AppDataManager.shared.userCountry = success
                }
                self.loadListNode()
            }
            
        }
        func loadListNode() {
            let listCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
            var listCity: [CountryCity] = [];
            
            for country  in listCountry {
                guard let cities =  country.city else {
                    continue
                }
                cities.forEach { city in
                    var updateCity = city
                    updateCity.country = country
                    listCity.append(updateCity)
                }
               
            }
            
            print("contry count: \(listCountry.count)")
            
            self.listCountry = listCountry.map { country in
                return NodePoint(point: CGPoint(x: convertX (country.x), y: convertY(country.y) ), info: country)
            }
            
            self.listCity = listCity.map({ city in
                return NodePoint(point: CGPoint(x: convertX(Double(city.x ?? 0)), y: convertY(Double(city.y ?? 0))), info:  city)
            })
        }
    }
    
}



extension CountryCity : INodeInfo {
    var locationDescription: String? {
        return nil
    }
    
    var locationSubname: String? {
        return self.name
    }
    
    var locationName: String{
        return self.country?.name ?? ""
    }
    
    var state: VpnMapPontState {
        if GlobalAppStates.shared.displayState == .connected {
            return .disabled
        }
        return .normal
    }
    
    var localtionIndex: Int? {
        return 1
    }
    
    var image: KFImage? {
        guard let flagUrl = country?.flag,  let url = URL(string: flagUrl ) else {
            return nil
        }
        return  KFImage.url(url).placeholder { progress in
            ProgressView().progressViewStyle(CircularProgressViewStyle())

        }
    }
}

extension CountryAvailables : INodeInfo {
    var locationDescription: String? {
        return nil
    }
    
    var locationSubname: String? {
        return nil
    }
    
    var locationName: String{
        return name ?? ""
    }
    
    var state: VpnMapPontState {
        if GlobalAppStates.shared.displayState == .connected {
            return .disabled
        }
        return .normal
    }
    
    var localtionIndex: Int? {
        return nil
    }
    
    var image: KFImage? {
        guard let flagUrl = flag,  let url = URL(string: flagUrl) else {
            return nil
        }
        return  KFImage.url(url).placeholder { progress in
            ProgressView().progressViewStyle(CircularProgressViewStyle())

        }
    }
}
