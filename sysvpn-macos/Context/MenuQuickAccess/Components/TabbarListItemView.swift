//
//  TabbarListItemView.swift
//  sysvpn-macos
//
//  Created by doragon on 26/10/2022.
//

import SwiftUI

struct TabbarListItemView: View {
    var listItem: [TabbarListItemModel]
    var onTap: ((INodeInfo) -> Void)?
    var body: some View {
        VStack(alignment: .leading) {
            List(listItem) { item in
                TabbarItemView(model: item)
                    .onTapGesture {
                        if let node = item.raw {
                            onTap?(node)
                        }
                    }
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
    var imageUrl: String?
    var lastUse: Date = .init()
    var isConnecting: Bool = false
    var isShowDate: Bool = false
    var raw: INodeInfo?
}
