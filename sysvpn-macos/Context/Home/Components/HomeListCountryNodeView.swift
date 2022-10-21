//
//  HomeListCountryNodeView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI
struct HomeListCountryNodeView : View {
    @Binding var selectedItem: HomeMenuItem 
    @Binding var countries: [HomeListCountryModel]
    var body: some View {
        VStack(alignment: .leading) { 
            List(countries) {  item in
                switch item.type {
                case .spacing:
                    Spacer().frame(height: 30)
                case .country:
                    if selectedItem == .manualConnection {
                        CountryItemView(countryName: item.title, imageUrl: item.imageUrl, totalCity: item.totalCity)
                    } else if selectedItem == .staticIp {
                        StaticItemView(countryName: item.title, cityName: item.cityName, imageUrl: item.imageUrl, serverNumber: item.serverNumber)
                    } else if selectedItem == .multiHop {
                        CountryItemView(countryName: item.title, imageUrl: item.imageUrl, totalCity: item.totalCity)
                    }
                case .header:
                    VStack {
                        Text(item.title)
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                            .font(Font.system(size: 14, weight: .regular))
                        Spacer().frame(height: 21)
                    }
                }
            }
            .modifier(ListViewModifier())
            
             
        }
        
        .padding(.horizontal, 23)
        .frame(width: 300, alignment: .leading)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
        
        .overlay {
            Asset.Assets.icClose.swiftUIImage.padding(10)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
            .position(x: 315, y: 0)
            .allowsHitTesting(true)
            .onTapGesture {
                withAnimation {
                    selectedItem = .none
                }
            }
        }
       
    }
}

enum HomeListCountryModelType {
    case header
    case country
    case spacing
}

struct HomeListCountryModel: Identifiable {
    var id = UUID()
    var type: HomeListCountryModelType
    var title: String = ""
    var totalCity: Int = 0
    var imageUrl:String?
    var cityName: String = ""
    var serverNumber: Int = 0
}


struct ListViewModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content 
    }
}
