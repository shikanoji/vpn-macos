//
//  SettingSwitchComponent.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import SwiftUI

struct SettingSwitchComponent: View {
    var title: String
    var desc: String?
    @State var isActive = true
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                    .padding(.bottom, 2)
                if desc != nil {
                    Text(desc!)
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                        .font(Font.system(size: 14, weight: .regular))
                }
            }
            Spacer()
            Toggle("", isOn: $isActive)
                .toggleStyle(SwitchToggleStyle(tint: Asset.Colors.primaryColor.swiftUIColor))
        }
        .padding(.vertical, 15)
    }
}

struct SettingSwitchComponent_Previews: PreviewProvider {
    static var previews: some View {
        SettingSwitchComponent(title: "12312")
    }
}
