//
//  StatisticsSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct StatisticsSettingView: View {
    @StateObject private var viewModel = StatisticsSettingViewModel()
    var body: some View {
        VStack (alignment: .center){
       
            HStack (alignment: .center) {
                
                VStack (alignment: .center, spacing: 24) {
                    ForEach(viewModel.listItem) { item in
                         HStack {
                            Text(item.settingType)
                                .foregroundColor(Color.white)
                                .font(Font.system(size: 14, weight: .regular))
                            Spacer()
                            Text(item.settingContent)
                                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                                .font(Font.system(size: 14, weight: .regular))
                        }
                    }
                }
                .padding(30)
                .frame(width: 480)
                .background(Asset.Colors.headerSettingColor.swiftUIColor)
                .cornerRadius(16)
              
            }
        }
        .frame(maxWidth: .infinity, minHeight: 390)
    }
}

struct StatisticsSettingView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSettingView()
    }
}
