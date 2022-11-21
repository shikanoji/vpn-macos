//
//  LoginViewModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/09/2022.
//

import Foundation
import RxSwift
import SwiftUI
import SwiftyJSON


extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        @Published var userName: String = "test@gmail.com"
        @Published var password: String = "X12345678"
        @Published var isEditingEmail: Bool = false
        @Published var isEditingPassword: Bool = false
        @Published var isRemember: Bool = false
        @Published var isPresentedLoading = false
        @Published var isVerifiedInput = true
        @Environment(\.openURL) private var openURL
        @Published var showAlert = false
        @Published var errorMessage: String = ""
        var signInHelper: SocialSigninHelper!
        
        init() {
            isRemember = AppSetting.shared.isRememberLogin
            let isReady = GlobalAppStates.shared.initApp { [weak self] in
                self?.hideLoading()
            }
            
            if isReady {
                isPresentedLoading = true
            }
            
            signInHelper = SocialSigninHelper(onResult: {  [weak self] result in
                switch result {
                case .failure(let error):
                    self?.showAlert = true
                    self?.errorMessage = error.localizedDescription
                    break
                case .success(let data):
                    self?.onLoginSuccess(result: data)
                }
            }) 
        }
        
        func onViewAppear() {}
        
        func onLoginSuccess() {
            AppSetting.shared.isRememberLogin = isRemember
            OpenWindows.MainView.open()
            NotificationCenter.default.post(name: .startJobUpdateCountry, object: nil)
        }
        
        func loadCountry() {
            _ = APIServiceManager.shared.getListCountry().subscribe { result in
                switch result {
                case let .success(response):
                    AppDataManager.shared.userCountry = response
                    self.onLoginSuccess()
                case let .failure(e):
                    self.hideLoading()
                    guard let error = e as? ResponseError else {
                        self.errorMessage = L10n.Login.tryAgain
                        self.showAlert = true
                        return
                    }
                    self.errorMessage = error.message
                    self.showAlert = true
                }
            }
        }
        
        func onTouchSignin() {
            showLoading()
            _ = APIServiceManager.shared.onLogin(email: userName, password: password).subscribe { event in
                switch event {
                case let .success(authenModel):
                    AppDataManager.shared.userData = authenModel.user
                    AppDataManager.shared.accessToken = authenModel.tokens?.access
                    AppDataManager.shared.refreshToken = authenModel.tokens?.refresh
                    self.loadCountry()
                    self.hideLoading()
                case let .failure(e):
                    self.hideLoading()
                    guard let error = e as? ResponseError else {
                        self.errorMessage = L10n.Login.tryAgain
                        self.showAlert = true
                        return
                    }
                    self.errorMessage = error.message
                    self.showAlert = true
                }
            }
        }
        
        func showLoading() {
            withAnimation {
                self.isPresentedLoading = true
            }
        }
        
        func hideLoading() {
            withAnimation {
                self.isPresentedLoading = false
            }
        }
        
        func onTouchForgotPassword() {
            print("Forgot button was tapped:   \(AppSetting.shared.deviceVersion)")
        }
        
        func onTouchCreateAccount() {
            print("Creat new button was tapped")
            if let url = URL(string: "https://www.facebook.com/doragon0") {
                openURL(url)
            }
        }
        
        func onTouchSocialLoginGoogle() {
            signInHelper.googleLogin()
        }
        
        
        
        func onLoginSuccess(result: LoginSType) {
            
        }
        
        func onTouchSocialLoginApple() {
            signInHelper.appleLogin()
        }
        
        func verifyInputLogin() {
            isVerifiedInput = !userName.isEmpty && !password.isEmpty
        }
        
       
    }
    
}

