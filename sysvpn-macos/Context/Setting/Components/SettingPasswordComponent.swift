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
    @State var errorMessage: String = ""
    @State var hasError: Bool = false
    @State var isVerifiedInput: Bool = false
    
    var onTapAccept: @MainActor (_ currentPass: String, _ newPass: String) -> Single<EmptyData>
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
                    if self.settingPasswordState == .input {
                        self.settingPasswordState = .none
                        currentPass = ""
                        newPass = ""
                        confirmPass = ""
                    } else {
                        self.settingPasswordState = .input
                    }
                }
            }
            .padding(.vertical, 15)
            if settingPasswordState == .input {
                ChangePasswordItem(currenPassword: $currentPass, newPassword: $newPass, confirmPassword: $confirmPass, isVerifiedInput: isVerifiedInput, errorMessage: errorMessage, hasError: hasError, onTapAccept: {
                    _ = onTapAccept(currentPass, newPass).subscribe { result in
                        switch result {
                        case .success:
                            settingPasswordState = .success
                            currentPass = ""
                            newPass = ""
                            confirmPass = ""
                        case let .failure(e):
                            guard let error = e as? ResponseError else {
                                self.errorMessage = L10n.Global.unknowError
                                self.hasError = true
                                return
                            }
                            print("Error: \(error.error)")
                            errorMessage = error.error.isEmpty ? L10n.Global.unknowError : error.error
                            hasError = true
                        }
                    }
                    
                }, onChangeText: {
                    if !currentPass.isEmpty && newPass.count >= 8 && newPass == confirmPass {
                        isVerifiedInput = true
                        hasError = false
                    } else if newPass.count <= 8 {
                        hasError = false
                        if !newPass.isEmpty {
                            hasError = true
                            errorMessage = L10n.Global.unsatisfactoryPassword
                        }
                        isVerifiedInput = false
                    } else if newPass != confirmPass {
                        hasError = false
                        if !confirmPass.isEmpty {
                            hasError = true
                            errorMessage = L10n.Global.passNotMatch
                        }
                        isVerifiedInput = false
                    }
                    else {
                        hasError = false
                        isVerifiedInput = false
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
    var isVerifiedInput: Bool
    var errorMessage: String = ""
    var hasError: Bool
    @FocusState private var focusState: Field?
    var onTapAccept: () -> Void
    var onChangeText: () -> Void
    
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
            if hasError {
                Text(errorMessage)
                    .foregroundColor(Asset.Colors.errorColor.swiftUIColor)
                    .font(Font.system(size: 12, weight: .semibold))
            } else {
                Spacer().frame(height: 5)
            }
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
        .onChange(of: currenPassword, perform: { _ in
            onChangeText()
        })
        .onChange(of: newPassword) { _ in
            onChangeText()
        }.onChange(of: confirmPassword) { _ in
            onChangeText()
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
