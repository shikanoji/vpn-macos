//
//  ProfileTabbar.swift
//  sysvpn-macos
//
//  Created by macbook on 20/11/2022.
//

import Foundation
import SwiftUI

struct ProfileTabbarView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { proxy in
                Group {
                    Rectangle().fill(Color.white)
                        .frame(width: (proxy.size.width - 8) / 2)
                        .cornerRadius(15)
                    
                    HStack {
                        Text("Manual")
                            .font(.system(size: 12, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.black)
                        
                        Text("Profiles")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    }
                    .frame(height: proxy.size.height - 8)
                }
                .padding(4)
            }
                
        }.background(Asset.Colors.secondary3.swiftUIColor)
            .frame(height: 36)
            .cornerRadius(18)
    }
}

struct ProfileTabbarView_Previews: PreviewProvider {
    @State static var selectedItem: HomeMenuItem = .none
    
    static var previews: some View {
        ProfileTabbarView()
            .frame(width: 240, height: 40)
            .environmentObject(GlobalAppStates.shared)
    }
}
 