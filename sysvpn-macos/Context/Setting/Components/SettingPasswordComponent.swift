//
//  SettingPasswordComponent.swift
//  sysvpn-macos
//
//  Created by doragon on 04/11/2022.
//

import SwiftUI

enum SettingPasswordState {
    case none
    case input
    case success
}

struct SettingPasswordComponent: View {
    var title: String
    var desc: String?
    var isShowChangePass: Bool = false
    @State var isActive = true
    @State private var name = ""
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(.bottom, 2)
                    if desc != nil {
                        Text(desc!)
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                            .font(Font.system(size: 14, weight: .regular))
                    }
                }
                Spacer()
                Asset.Assets.icKey.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(L10n.Global.changePassword)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 14, weight: .regular))
            }
            .padding(.vertical, 15)
            ChangePasswordSuccessItem()
            //ChangePasswordItem(currenPassword: $name)
            
        }
    }
}

struct ChangePasswordItem: View {
    @Binding var currenPassword: String;
    @State var isActive = true
    var body: some View {
        VStack {
            formInput
        }
    }
    
    var formInput: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField(L10n.Global.currentPassword, text: $currenPassword)
                .textFieldStyle(LoginInputTextFieldStyle(focused: $isActive))
                .frame(width: 266)
            HStack (spacing: 10) {
                SecureField(L10n.Global.newPassword, text: $currenPassword)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $isActive))
                    .textContentType(nil)
                SecureField(L10n.Global.confirmPassword, text: $currenPassword)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $isActive))
                    .textContentType(nil)
            }
            Spacer().frame(height: 20)
            
            Button {
                //
            } label: {
                Text(L10n.Global.changePassword)
            }.buttonStyle(LoginButtonCTAStyle())
                .frame(width: 170, height: 48)
        }
    }
}
 

struct ChangePasswordSuccessItem: View {
    var body: some View {
        HStack {
            Asset.Assets.icTickActive.swiftUIImage
                .resizable()
                .frame(width: 16, height: 16)
            Text(L10n.Global.changePasswordSuccess)
                .foregroundColor(Asset.Colors.primaryColor.swiftUIColor)
                .font(Font.system(size: 14, weight: .regular))
        }
        .frame(width: 266, height: 50)
        .background(Asset.Colors.headerSettingColor.swiftUIColor)
        .cornerRadius(8)
    }
     
}
