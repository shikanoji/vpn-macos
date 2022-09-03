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
            Asset.Assets.logoF1.swiftUIImage
                .resizable()
                .frame(width: 100, height: 116, alignment: .center)
            Text(L10n.Global.hello)
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
