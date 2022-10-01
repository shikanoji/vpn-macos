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
            .font(Font.system(size: 14))
            .foregroundColor(isSelected ? Asset.Colors.primaryColor.swiftUIColor : Asset.Colors.mainTextColor.swiftUIColor)
            .frame(maxWidth: 100, minHeight: 52, alignment: .center)
    }
}
