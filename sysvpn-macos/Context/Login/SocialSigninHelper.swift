//
//  SocialSigninHelper.swift
//  sysvpn-macos
//
//  Created by macbook on 21/11/2022.
//

import Foundation
import GoogleSignIn
import AuthenticationServices

enum LoginSType {
    case google(accessToken: String)
    case apple(idToken: Data)
}

class SocialSigninHelper: NSObject, ASAuthorizationControllerDelegate {
    
    let clientId = "453919423468-lmo1l9586u0901hbupmaju81qr413cqc.apps.googleusercontent.com"
    
    var onResult: (( Result<LoginSType, Error> ) -> Void)?
    
    init(onResult: (@escaping (Result<LoginSType, Error>) -> Void)) {
        self.onResult = onResult
    }
    
    func googleLogin() {
        guard let viewController = NSApplication.shared.windows.first else {
            return
        }
        let signInConfig = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: viewController) { [weak self] (user, error) in
                if let error = error {
                    self?.onResult?( .failure(error) )
                    return
                }
                // print("signin success")
                let accessToken =  user?.authentication.idToken ?? ""
                self?.onResult?(.success(.google(accessToken: accessToken)))
            }
    }
    
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.onResult?( .failure(error) )
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential else
        {
            self.onResult?( .failure(  NSError(domain: "com.sysvpn.unknown", code: 0) ))
            return
        }
        self.onResult?(.success(.apple(idToken: appleIDCredential.identityToken ?? Data())))
    }
}
