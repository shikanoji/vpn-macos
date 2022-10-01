//
//  LoginButtonStyle.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/09/2022.
//

import Foundation
import SwiftUI

struct LoginButtonNoBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Asset.Colors.primaryColor.swiftUIColor : Color.white)
            .background(Color.clear)
    }
}

struct LoginButtonCTAStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        CTAButton(configuration: configuration)
    }

    struct CTAButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .padding(EdgeInsets(top: 13.0, leading: 8.0, bottom: 13.0, trailing: 8.0))
                .frame(maxWidth: .infinity)
                .foregroundColor(isEnabled ? Asset.Colors.foregroundButtonEnable.swiftUIColor : Asset.Colors.foregroundButtonDisable.swiftUIColor)
                .background(isEnabled ? Asset.Colors.primaryColor.swiftUIColor : Asset.Colors.backgroundButtonDisable.swiftUIColor)
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .cornerRadius(8)
        }
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        ActionButton(configuration: configuration)
    }
    
    struct ActionButton: View {
        let configuration: ButtonStyle.Configuration
        var body: some View {
            configuration.label
                .padding(EdgeInsets(top: 6.0, leading: 0, bottom: 6.0, trailing: 0))
                .frame( maxHeight: 40)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hexString: "#353748"), lineWidth: 1))
        }
    }
}
