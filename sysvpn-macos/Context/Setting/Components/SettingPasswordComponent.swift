//
//  SettingPasswordComponent.swift
//  sysvpn-macos
//
//  Created by doragon on 04/11/2022.
//

import SwiftUI
import Moya
import RxSwift
import SwiftUI
import SwiftyJSON

enum SettingPasswordState {
    case none
    case input
    case success
    case failure
}

private enum Field: Int, Hashable {
    case password, newPassword, confirmPassword
}

struct SettingPasswordComponent: View {
    var data: ChangePasswordSettingItem
    var isShowChangePass: Bool = false
    
    @State var settingPasswordState: SettingPasswordState = .none
    @State var isActive = true
    @State var currentPass: String = ""
    @State var newPass: String = ""
    @State var confirmPass: String = "" 
    
    var onTapAccept: @MainActor (_ currentPass: String, _ newPass: String) -> Single<Bool>
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(data.settingName)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 14, weight: .semibold))
                        .padding(.bottom, 2)
                    if data.settingDesc != nil {
                        Text(data.settingDesc!)
                            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                            .font(Font.system(size: 12, weight: .regular))
                    }
                }
                Spacer()
                Group {
                    Asset.Assets.icKey.swiftUIImage
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(L10n.Global.changePassword)
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 12, weight: .regular))
                }
                .onTapGesture {
                    self.settingPasswordState = .input
                }
            }
            .padding(.vertical, 15)
            if settingPasswordState == .input {
                ChangePasswordItem(currenPassword: $currentPass, newPassword: $newPass, confirmPassword: $confirmPass, onTapAccept: {
                    onTapAccept(currentPass, newPass).subscribe { result in
                        switch result {
                        case let .success(res):
                            if res {
                                settingPasswordState = .success
                            } else {
                                settingPasswordState = .failure
                            }
                        case let .failure(e):
                            print("Error: \(e)")
                        }
                        currentPass = ""
                        newPass = ""
                        confirmPass = ""
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
    @Binding var newPassword: String
    @Binding var confirmPassword: String
    @State var isCurrentPass = false
    @State var isNewPass = false
    @State var isRepass = false
    @State var isVerifiedInput: Bool = false
    @FocusState private var focusState: Field?
    var onTapAccept: () -> Void
    var body: some View {
        VStack {
            formInput
        }
    }
    
    var formInput: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField(L10n.Global.currentPassword, text: $currenPassword)
                .textFieldStyle(LoginInputTextFieldStyle(focused: $isCurrentPass))
                .focused($focusState, equals: .password)
                .frame(width: 246)
            HStack(spacing: 10) {
                SecureField(L10n.Global.newPassword, text: $newPassword)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $isNewPass))
                    .focused($focusState, equals: .newPassword)
                    .textContentType(nil)
                SecureField(L10n.Global.confirmPassword, text: $confirmPassword)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $isRepass))
                    .focused($focusState, equals: .confirmPassword)
                    .textContentType(nil)
            }
            Spacer().frame(height: 5)
            Button {
                onTapAccept()
            } label: {
                Text(L10n.Global.changePassword)
            }.buttonStyle(LoginButtonCTAStyle())
                .frame(width: 170, height: 48)
                .environment(\.isEnabled, isVerifiedInput)
        }
        .onChange(of: focusState) { newValue in
            isCurrentPass = newValue == .password
            isNewPass = newValue == .newPassword
            isRepass = newValue == .confirmPassword
        }
        .onChange(of: newPassword) { _ in
            isVerifiedInput = (newPassword == confirmPassword && !newPassword.isEmpty)
        }.onChange(of: confirmPassword) { _ in
            isVerifiedInput = (newPassword == confirmPassword && !confirmPassword.isEmpty)
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
