//
//  TabbarComponent.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI
 
struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .font(Font.system(size: 12))
            .foregroundColor(isSelected ? Asset.Colors.primaryColor.swiftUIColor : Asset.Colors.mainTextColor.swiftUIColor)
            .frame(minHeight: 45, alignment: .center)
            .padding(.horizontal, 15)
    }
}
