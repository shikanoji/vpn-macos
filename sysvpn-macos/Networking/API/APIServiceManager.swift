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
     
 
    func onLogin(email: String, password: String) -> Single<AuthResult> {
        return request(.login(email: email, password: password)).handleApiResponseCodable(type: AuthResult.self) 
    }
    
    func getAppSetting() -> Single<AppSettingResult> {
        return request(.getAppSettings).handleApiResponseCodable(type: AppSettingResult.self)
    }
    
    func getAppSettingFirstOpen() -> Single<AppSettingResult> {
        return request(.getAppSettings).handleApiResponseCodable(type: AppSettingResult.self)
    }
    
    func getListCountry()  -> Single<CountryResult> {
        return request(.getListCountry).handleApiResponseCodable(type: CountryResult.self)
    }
    
    func onLogout() -> Single<Bool> {
        return request(.logout).handleEmptyResponse() 
    }
    
    func onRequestCert(param: VpnParamRequest) -> Single<VPNResult> {
        return request(.requestCert(vpnParam: param)).handleApiResponseCodable(type: VPNResult.self)
    }
    
    func onDisconnect() -> Single<Bool>{
        return request(.disconnectSession(sectionId: "", disconnectedBy: "")).handleEmptyResponse()
    }
    
    func getStartServer() -> Single<ServerStateResult>{
        return request(.getStartServer).handleApiResponseCodable(type: ServerStateResult.self)
    }
    
    
}
