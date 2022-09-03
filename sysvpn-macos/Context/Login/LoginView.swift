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
                
                TextField("Your email", text: $viewModel.userName)
                    .padding(EdgeInsets(top: 60, leading: 60, bottom: 16, trailing: 60))
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $viewModel.isEditingEmail))
                    .disableAutocorrection(true)
                    .focused($focusState, equals: .username)
                    .onChange(of: focusState) { newValue in
                        viewModel.isEditingEmail = newValue == .username
                    }
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(LoginInputTextFieldStyle(focused: $viewModel.isEditingPassword))
                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 30, trailing: 60))
                    .focused($focusState, equals: .password)
                    .textContentType(.password)
                    .onChange(of: focusState) { newValue in
                        viewModel.isEditingPassword = newValue == .password
                    }
                
                HStack(alignment: .center) {
                    Button {
                        viewModel.isRemember = !viewModel.isRemember
                    } label: {
                        if viewModel.isRemember { Asset.Assets.icCheckNormal.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        } else {
                            Asset.Assets.icCheckChecked.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                        Text(L10n.Login.rememberLogin)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                    Spacer()
                    Button {
                        print("Edit button was tapped")
                    } label: {
                        Text(L10n.Login.forgotPassword)
                    }.buttonStyle(LoginButtonNoBackgroundStyle())
                }
                .padding(EdgeInsets(top: 0, leading: 60, bottom: 46, trailing: 60))
                
                Button {
                    print("sign button was tapped")
                    withAnimation {
                        viewModel.isPresentedLoading = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            self.viewModel.isPresentedLoading = false
                        }
                    }
                } label: {
                    Text(L10n.Login.signIn)
                }.buttonStyle(LoginButtonCTAStyle())
                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 32, trailing: 60))
                
                HStack(alignment: .center) {
                    Button {
                        print("social login button was tapped")
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
                        print("social login button was tapped")
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
                        print("create button was tapped")
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
