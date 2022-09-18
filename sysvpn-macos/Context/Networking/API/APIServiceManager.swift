//
//  APIServiceManager.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 31/08/2022.
//

import Moya
import RxSwift
import SwiftUI
import SwiftyJSON
final class APIServiceManager: BaseServiceManager<APIService> {
    static let shared = APIServiceManager()
    
    // This is the provider for the service we defined earlier
//    var provider: MoyaProvider<APIService>
//
//    private init() {
//        let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
//        self.provider = MoyaProvider<APIService>(requestClosure: MoyaProvider<APIService>.endpointResolver(), plugins: [plugin])
//        self.provider.session.sessionConfiguration.timeoutIntervalForRequest = 10
//        self.provider.session.sessionConfiguration.timeoutIntervalForResource = 10
//    }
     
    func onLogin(email: String, password: String, completed: ((APICallerResult<UserModel?>) -> Void)?) {
        request(.login(email: email, password: password)).subscribe { event in
            completed?(APIServiceManager.handleResult(type: UserModel.self, input: event)) 
        }

    }
}
