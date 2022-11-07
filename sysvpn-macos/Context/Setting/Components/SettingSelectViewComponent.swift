//
//  SettingSelectViewComponent.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import SwiftUI

struct SettingSelectViewComponent: View {
    var selectItem: SettingElementType
    @State private var isShowingPopover = false
    @State var valueSelect: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(selectItem.settingName)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                    .padding(.bottom, 2)
                if selectItem.settingDesc != nil {
                    Text(selectItem.settingDesc!)
                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                        .font(Font.system(size: 14, weight: .regular))
                }
            }
            Spacer()
            if let data = selectItem as? SelectSettingItem<String> {
                HStack(spacing: 4) {
                    Asset.Assets.icArrowExpand.swiftUIImage
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(valueSelect)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 14, weight: .regular))
                }
                .onTapGesture {
                    self.isShowingPopover = true
                }
                .popover(isPresented: $isShowingPopover, arrowEdge: .bottom, content: {
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 12)
                        ForEach(data.settingData ?? [], id: \.self) { item in
                            HStack {
                                Spacer().frame(width: 16)
                                Text(item)
                                    .foregroundColor(Color.white)
                                    .font(Font.system(size: 16, weight: .semibold))
                                    
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                valueSelect = item
                                self.isShowingPopover = false
                            }
                            .frame(height: 40)
                            .background(item == valueSelect ? Asset.Colors.popoverBgSelected.swiftUIColor : Asset.Colors.popoverBgColor.swiftUIColor)
                        }
                        Spacer()
                    }
                    .frame(width: 180, height: 200)
                    .background(Asset.Colors.popoverBgColor.swiftUIColor)
                })
            }
        }
        .padding(.vertical, 15)
    }
}
 