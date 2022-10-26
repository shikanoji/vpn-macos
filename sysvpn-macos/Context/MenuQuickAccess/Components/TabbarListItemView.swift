//
//  TabbarListItemView.swift
//  sysvpn-macos
//
//  Created by doragon on 26/10/2022.
//

import SwiftUI

struct TabbarListItemView: View {
    @Binding var selectedItem: TabbarMenuItem
    @Binding var listItem: [TabbarListItemModel]
    var body: some View {
        VStack(alignment: .leading) {
            List(listItem) {  item in
                TabbarItemView(countryName: item.title, imageUrl: item.imageUrl, totalCity: item.totalCity)
            }
            .modifier(ListViewModifier())
            .animation(nil, value: UUID())
        }
        .padding(.horizontal, 6)
        .frame(width: 360, alignment: .leading)
    }
}
 

struct TabbarListItemModel: Identifiable {
    var id = UUID()
    var title: String = ""
    var totalCity: Int = 0
    var imageUrl:String? 
    var lastUse: Date = Date()
}

