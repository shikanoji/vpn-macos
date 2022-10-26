//
//  TabbarItemView.swift
//  sysvpn-macos
//
//  Created by doragon on 26/10/2022.
//

import SwiftUI
import Kingfisher

struct TabbarItemView: View {
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
                Asset.Assets.icFlagEmpty.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
            }
            VStack(alignment: .leading) {
                Text(countryName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 14, weight: .semibold))
                Spacer().frame(height: 4)
                Text(totalCity >= 1 ? "\(totalCity) cities available" : "Single location")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 13, weight: .regular))
            }
        }.padding(.bottom, 10)
    }
} 
