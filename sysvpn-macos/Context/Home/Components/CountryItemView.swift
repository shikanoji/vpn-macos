//
//  CountryItemView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI
struct CountryItemView : View {
    var countryName:String
    var imageUrl:String?
    var totalCity: Int
    var body: some View {
        HStack (alignment: .center, spacing: 16) {
            if imageUrl != nil {
                AsyncImage(url: URL(string: imageUrl!)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.black.opacity(0.1)
                        }
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
                Text(totalCity > 1 ? "\(totalCity) cities available" : "Single location")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 14, weight: .regular))
            }
        }.padding(.bottom, 10)
    }
}
