//
//  CountryItemView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation
import SwiftUI
struct CountryItemView : View {
    var body: some View {
        HStack (alignment: .center, spacing: 16) {
            Asset.Assets.demoCountry.swiftUIImage
            VStack(alignment: .leading) {
                Text("Poland")
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                Text("Sinbgle location")
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 14, weight: .regular))
            }
        }.padding(.bottom, 10)
    }
}
