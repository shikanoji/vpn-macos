//
//  LoginViewModel.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/09/2022.
//

import Foundation
import RxSwift
 
extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        @Published var userName: String = ""
        @Published var password: String = ""
        @Published var isEditingEmail: Bool = false
        @Published var isEditingPassword: Bool = false
        @Published var isRemember: Bool = false
        
        @Published var isPresentedLoading = false
    }
}
