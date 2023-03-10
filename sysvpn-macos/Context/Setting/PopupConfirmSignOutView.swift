//
//  PopupConfirmSignOutView.swift
//  sysvpn-macos
//
//  Created by doragon on 23/11/2022.
//

import SwiftUI

struct PopupConfirmSignOutView: View {
    var onCancel: (() -> Void)?
    var onLogout: (() -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(L10n.Global.confirmSignOut)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
                    .padding(.top, 30)
                 
                Text(L10n.Global.signOutDesc)
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(Font.system(size: 13, weight: .regular))
                    .padding(EdgeInsets(top: 12, leading: 32, bottom: 0, trailing: 32))
                HStack(spacing: 11) {
                    Button {
                        onCancel?()
                    } label: {
                        Text(L10n.Global.cancel)
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 13, weight: .semibold))
                    }.buttonStyle(LoginButtonCTAStyle(bgColor: Asset.Colors.buttonCancelColor.swiftUIColor))
                        .frame(width: 110, height: 40)
                    
                    Button {
                        onLogout?()
                    } label: {
                        HStack(spacing: 10) {
                            Text(L10n.Global.titleLogout)
                                .foregroundColor(Color.black)
                                .font(Font.system(size: 13, weight: .semibold))
                            Asset.Assets.icRightArrow.swiftUIImage
                                .resizable()
                                .frame(width: 12, height: 12)
                        }
                    }.buttonStyle(LoginButtonCTAStyle())
                        .frame(width: 110, height: 40)
                }
                .padding(.vertical, 32)
            }
            .contentShape(Rectangle())
            .background(Asset.Colors.bodySettingColor.swiftUIColor)
        }
        .cornerRadius(16)
        .frame(width: 350, height: 200, alignment: .center)
        .frame(minWidth: 10, maxWidth: 350)
    }
}

struct PopupConfirmSignOutView_Previews: PreviewProvider {
    static var previews: some View {
        PopupConfirmSignOutView()
    }
}
