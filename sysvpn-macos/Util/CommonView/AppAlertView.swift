//
//  AppAlertView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 28/09/2022.
//

import Foundation
import SwiftUI

enum AppAlertType {
    case error
    case success
    case info
    case warning
    
    var color: Color {
        switch self {
        case .error:
            return Asset.Colors.errorColor.swiftUIColor
        case .info:
            return Asset.Colors.infoColor.swiftUIColor
        case .warning:
            return Asset.Colors.warningColor.swiftUIColor
        case .success:
            return Asset.Colors.successColor.swiftUIColor
        }
    }
    
    var icon: Image {
        return Asset.Assets.icAlertError.swiftUIImage
    }
}

struct AppAlertView: View {
    var type: AppAlertType
    var message: String
    
    var body: some View {
        ZStack(content: {
            type.color.ignoresSafeArea()
            HStack(alignment: .center, spacing: 16) {
                type.icon
                Text(message)
                    .foregroundColor(Color.white)
                
                Spacer()
            }
            .padding(
                EdgeInsets(top: 27, leading: 36, bottom: 27, trailing: 36)
            )
        })
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct AppAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AppAlertView(type: .error, message: "Hello job")
    }
}
