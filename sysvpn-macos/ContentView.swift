//
//  ContentView.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 29/08/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Asset.Assets.logo.swiftUIImage
            Text(L10n.hello)
                .padding()
        }
        .frame(width: 600, height: 600)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
        .foregroundColor(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
