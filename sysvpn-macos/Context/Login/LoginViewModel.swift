//
//  LoginViewModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/09/2022.
//

import Foundation
import RxSwift
import SwiftUI

extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        @Published var userName: String = ""
        @Published var password: String = ""
        @Published var isEditingEmail: Bool = false
        @Published var isEditingPassword: Bool = false
        @Published var isRemember: Bool = false
        @Published var isPresentedLoading = false
        @Published var isVerifiedInput = false
        @Published var showAlert = true
        
        init() {
            isRemember = AppSetting.shared.isRememberLogin
        }
        
        func onTouchSignin() {
            // test
            AppSetting.shared.isRememberLogin = isRemember
            withAnimation {
                self.isPresentedLoading = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.isPresentedLoading = false
                }
            }
        }
        
        func onTouchForgotPassword() {
            print("Forgot button was tapped")
        }
        
        func onTouchCreateAccount() {
            print("Creat new button was tapped")
        }
    
        func onTouchSocialLoginGoogle() {
            print("Google button was tapped")
        }
        
        func onTouchSocialLoginApple() {
            print("Apple button was tapped")
        }
        
        func verifyInputLogin() {
            isVerifiedInput = !userName.isEmpty && !password.isEmpty
        }
    }
}
