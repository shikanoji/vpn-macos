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
    var percent: Int = 1
    var body: some View {
        HStack (alignment: .center, spacing: 0) {
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
            Spacer().frame(width: 16)
            Asset.Assets.icStaticServer.swiftUIImage
                .resizable()
                .frame(width: 16, height: 16)
            Spacer().frame(width: 16)
            VStack(alignment: .leading) {
                Text(countryName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                Text("\(cityName) #\(serverNumber)")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 14, weight: .regular))
            }
            Spacer()
            ZStack  {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color(rgb: 0x2E303D))
                    .frame(width: 40, height: 6)
                    .cornerRadius(3)
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(rgb:0x0CBC92), Color(rgb:0xCEA71B), Color(rgb:0xBF1616)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 40, height: 6)
                    .clipShape(CustomProcessShape(percent: percent))
                
            }
        }.padding(.bottom, 10)
    }
}

struct CustomProcessShape: Shape {
    var percent: Int = 1
    func path(in rect: CGRect) -> Path {
        let width = CGFloat(percent) / 10 * rect.width
        var path = Path()
        path.addRoundedRect(in: CGRect(origin: .zero, size: CGSize(width: width, height: rect.height)), cornerSize: CGSize(width: rect.height / 2, height: rect.height / 2))
        return path
    }
    
    
}
