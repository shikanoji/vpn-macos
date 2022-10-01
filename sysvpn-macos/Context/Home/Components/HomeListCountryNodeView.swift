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
    var countries = [
        HomeListCountryModel(type: .header, title: "Recent locations"),
        HomeListCountryModel(type: .country, title: "Test1"),
        HomeListCountryModel(type: .spacing),
        HomeListCountryModel(type: .header, title: "Recommended"),
        HomeListCountryModel(type: .country, title: "Test2"),
        HomeListCountryModel(type: .country, title: "Test3"),
        HomeListCountryModel(type: .spacing),
        HomeListCountryModel(type: .header, title: "All countries"),
        HomeListCountryModel(type: .country, title: "Test4"),
        HomeListCountryModel(type: .country, title: "Test5"),
        HomeListCountryModel(type: .country, title: "Test6"),
        HomeListCountryModel(type: .country, title: "Test7"),
        HomeListCountryModel(type: .country, title: "Test4"),
        HomeListCountryModel(type: .country, title: "Test5"),
        HomeListCountryModel(type: .country, title: "Test6"),
        HomeListCountryModel(type: .country, title: "Test7"),
        HomeListCountryModel(type: .country, title: "Test4"),
        HomeListCountryModel(type: .country, title: "Test5"),
        HomeListCountryModel(type: .country, title: "Test6"),
        HomeListCountryModel(type: .country, title: "Test7")
    ]
    var body: some View {
        VStack(alignment: .leading) {
           /* Text("Recent locations")
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                .font(Font.system(size: 14, weight: .regular))
            Spacer().frame(height: 21)
            CountryItemView()
            Text("Recommended")
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                .font(Font.system(size: 14, weight: .regular))
            Spacer().frame(height: 21)
            CountryItemView()
            Text("All countries")
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                .font(Font.system(size: 14, weight: .regular))
            Spacer().frame(height: 21)
            CountryItemView()
            Spacer()*/
            
            List(countries) {  item in
                switch item.type {
                case .spacing:
                    Spacer().frame(height: 30)
                case .country:
                    CountryItemView()
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
}


struct ListViewModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content 
    }
}
