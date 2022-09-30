//
//  MenuQuickAccessView.swift
//  sysvpn-macos
//
//  Created by doragon on 29/09/2022.
//

import SwiftUI
 
struct MenuQuickAccessView: View {
    @StateObject private var viewModel = MenuQuickAccessModel()
    
    var body: some View {
        VStack {
            headerMenu
            bodyMenu
            footerMenu
        }
        .cornerRadius(8)
    }
    
    var headerMenu: some View {
        VStack {
            Text(viewModel.userIp)
                .lineLimit(nil)
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                .padding(.top, 14)
            Text(viewModel.location)
            Spacer()
        }
        .background(Color(hexString: "101016"))
        .frame(width: 400, height: 174)
    }
    
    var bodyMenu: some View {
        VStack {
            Text("Body Menu quick access")
            Spacer()
        }
        .frame(width: 400)
        .background(Color.red)
    }
    
    var footerMenu: some View {
        VStack {
            Text("footer Menu quick access")
            Spacer()
        }
        .frame(width: 400, height: 70)
        .background(Color.green)
    }
}

struct MenuQuickAccessView_Previews: PreviewProvider {
    static var previews: some View {
        MenuQuickAccessView()
    }
}
