//
//  CountryItemView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI
import Kingfisher
struct CountryItemView : View {
    var countryName:String
    var imageUrl:String?
    var totalCity: Int
    var body: some View {
        HStack (alignment: .center, spacing: 16) {
            if imageUrl != nil {
                KFImage(URL(string: imageUrl!))
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            } else{
                Asset.Assets.avatarTest.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            }
            VStack(alignment: .leading) {
                Text(countryName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                Text(totalCity >= 1 ? "\(totalCity) cities available" : "Single location")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 14, weight: .regular))
            }
        }.padding(.bottom, 10)
    }
}

struct StaticItemView : View {
    var countryName:String
    var cityName:String
    var imageUrl:String?
    var serverNumber: Int
    var body: some View {
        HStack (alignment: .center, spacing: 16) {
            if imageUrl != nil {
                KFImage(URL(string: imageUrl!))
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            } else{
                Asset.Assets.avatarTest.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            }
            Asset.Assets.icStaticServer.swiftUIImage
                .resizable()
                .frame(width: 16, height: 16)
            VStack(alignment: .leading) {
                Text(countryName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                Text("\(cityName) #\(serverNumber)")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 14, weight: .regular))
            }
        }.padding(.bottom, 10)
    }
}
