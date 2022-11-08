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
    var data: ChangePasswordSettingItem
    var isShowChangePass: Bool = false
    @State var settingPasswordState: SettingPasswordState = .none
    @State var isActive = true
    @Binding var isChangePasswordSuccess: Bool
    @State private var name = ""
    var onTapAccept: @MainActor () -> ()
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(data.settingName)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(.bottom, 2)
                    if data.settingDesc != nil {
                        Text(data.settingDesc!)
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                            .font(Font.system(size: 14, weight: .regular))
                    }
                }
                Spacer()
                Group {
                    Asset.Assets.icKey.swiftUIImage
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(L10n.Global.changePassword)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 14, weight: .regular))
                }
                .onTapGesture {
                    self.settingPasswordState = .input
                }
                
            }
            .padding(.vertical, 15)
            if settingPasswordState == .input {
                ChangePasswordItem(currenPassword: $name, onTapAccept: {
                    onTapAccept()
                    if isChangePasswordSuccess {
                        settingPasswordState = .success
                    }
                })
            } else if settingPasswordState == .success {
                ChangePasswordSuccessItem()
            }
        }
    }
}

struct ChangePasswordItem: View {
    @Binding var currenPassword: String
    @State var isActive = true
    var onTapAccept : () -> ()
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
            Spacer().frame(height: 5)
            Button {
                onTapAccept()
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
