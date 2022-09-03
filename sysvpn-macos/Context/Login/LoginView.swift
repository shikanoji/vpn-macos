//
//  LoginView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/09/2022.
//

import Foundation
import SwiftUI

private enum Field: Int, Hashable {
    case username, password
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusState: Field?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Asset.Assets.logo.swiftUIImage
                    .padding(.top, 60)
                Text(L10n.Login.sologan)
                    .lineLimit(nil)
                    .font(Font.system(size: 16))
                    .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                    .font(.body)
                    .padding(.top, 14)
                
                TextField(L10n.Login.yourEmail, text: $viewModel.userName)
                    .padding(EdgeInsets(top: 60, leading: 60, bottom: 16, trailing: 60))
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $viewModel.isEditingEmail))
                    .disableAutocorrection(true)
                    .focused($focusState, equals: .username)
                
                SecureField(L10n.Login.password, text: $viewModel.password)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $viewModel.isEditingPassword))
                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 30, trailing: 60))
                    .focused($focusState, equals: .password)
                    .textContentType(.password)
                
                HStack(alignment: .center) {
                    Button {
                        viewModel.isRemember = !viewModel.isRemember
                    } label: {
                        if viewModel.isRemember { Asset.Assets.icCheckChecked.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        } else {
                            Asset.Assets.icCheckNormal.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                        Text(L10n.Login.rememberLogin)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                    Spacer()
                    Button {
                        viewModel.onTouchForgotPassword()
                    } label: {
                        Text(L10n.Login.forgotPassword)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                }
                .padding(EdgeInsets(top: 0, leading: 60, bottom: 46, trailing: 60))
                
                Button {
                    viewModel.onTouchSignin()
                } label: {
                    Text(L10n.Login.signIn)
                }.buttonStyle(LoginButtonCTAStyle())
                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 32, trailing: 60))
                    .environment(\.isEnabled, viewModel.isVerifiedInput)
                
                HStack(alignment: .center) {
                    Button {
                        viewModel.onTouchSocialLoginGoogle()
                    } label: {
                        Asset.Assets.icGoogle.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text(L10n.Login.signInWithGoogle)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                    Spacer()
                    Divider().frame(height: 24)
                    Spacer()
                    Button {
                        viewModel.onTouchSocialLoginApple()
                    } label: {
                        Asset.Assets.icApple.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text(L10n.Login.signInWithApple)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                }
                .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 60))
                
                VStack {
                    Text(L10n.Login.dontHaveAnAccount).foregroundColor(Asset.Colors.subTextColor.swiftUIColor).padding(.bottom, 4)
                    Button {
                        viewModel.onTouchCreateAccount()
                    } label: {
                        Text(L10n.Login.createNew)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                }
                .padding(EdgeInsets(top: 48, leading: 60, bottom: 0, trailing: 60))
                
                Spacer()
            }
            
            .background(Asset.Colors.backgroundColor.swiftUIColor)
            .foregroundColor(Color.white)
            .font(Font.system(size: 14))
            LoginLoadingView(isShowing: $viewModel.isPresentedLoading)
        }
        .onChange(of: focusState) { newValue in
            viewModel.isEditingPassword = newValue == .password
            viewModel.verifyInputLogin()
        }.onChange(of: focusState) { newValue in
            viewModel.isEditingEmail = newValue == .username
        }.onChange(of: viewModel.userName) { _ in
            viewModel.verifyInputLogin()
        }.onChange(of: viewModel.password) { _ in
            viewModel.verifyInputLogin()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
            NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
