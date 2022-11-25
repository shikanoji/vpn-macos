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
        return requestIPC(.login(email: email, password: password)).handleApiResponseCodable(type: AuthResult.self)
    }
    
    func getAppSetting() -> Single<AppSettingResult> {
        return requestIPC(.getAppSettings).handleApiResponseCodable(type: AppSettingResult.self)
    }
    
    func getAppSettingFirstOpen() -> Single<AppSettingResult> {
        return requestIPC(.getAppSettings).handleApiResponseCodable(type: AppSettingResult.self)
    }
    
    func getListCountry() -> Single<CountryResult> {
        return requestIPC(.getListCountry).handleApiResponseCodable(type: CountryResult.self)
    }
    
    func onLogout() -> Single<Bool> {
        return requestIPC(.logout).handleEmptyResponse()
    }
    
    func onRequestCert(param: VpnParamRequest) -> Single<VPNResult> {
        return requestIPC(.requestCert(vpnParam: param)).handleApiResponseCodable(type: VPNResult.self)
    }
     
    func onDisconnect(sectionId: String, disconnectedBy: String) -> Single<Bool> {
        return request(.disconnectSession(sectionId: sectionId, disconnectedBy: disconnectedBy)).handleEmptyResponse()
    }
    
    func getStartServer() -> Single<ServerStateResult> {
        return requestIPC(.getStartServer).handleApiResponseCodable(type: ServerStateResult.self)
    }
    
    func onRequestCertWireGuard(param: VpnParamRequest) -> Single<WireGuardResult> {
        return requestIPC(.requestCert(vpnParam: param)).handleApiResponseCodable(type: WireGuardResult.self)
    }
    
    func getListMultiHop() -> Single<[MultiHopResult]> {
        return requestIPC(.getListMutilHop).handleApiResponseCodable(type: [MultiHopResult].self)
    }
    
    
    func changePassword(oldPassword: String, newPassword: String) -> Single<EmptyData> { 
        return requestIPC(.changePassword(oldPassword: oldPassword, newPassword: newPassword)).handleApiResponseCodable(type: EmptyData.self)
    }
    
    func loginSocial (provider: String, token: String)  -> Single<AuthResult> {
        return requestIPC(.loginSocial(provider: provider, token: token)).handleApiResponseCodable(type: AuthResult.self)
    }
    
}


