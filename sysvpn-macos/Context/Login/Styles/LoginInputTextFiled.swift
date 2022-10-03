//
//  LoginInputTextFiled.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/09/2022.
//

import Foundation
import SwiftUI

struct LoginInputTextFieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(PlainTextFieldStyle())
            .frame(height: 50)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(focused ? Asset.Colors.primaryColor.swiftUIColor : Asset.Colors.borderColor.swiftUIColor, lineWidth: 1))
    }
}
