//
//  AppVpnService.swift
//  sysvpn-macos
//
//  Created by doragon on 18/10/2022.
//

import Foundation

class AppVpnService: SysVPNService {
    
    func prepareConection(connectType: ConnectionType, params: SysVPNConnectParams?, callback: SysVPNPrepareConnecitonStringCallback?) {
        let userSetting = AppDataManager.shared.userSetting
        let isWireGuard = userSetting?.appSettings?.settingVpn?.defaultTech?.contains("wg") ?? false
        let isUseUDP = userSetting?.appSettings?.settingVpn?.defaultProtocol?.contains("udp") ?? false
        let transportProtocol = isUseUDP ? OpenVpnTransport.udp : OpenVpnTransport.tcp
        let defaultTech = isWireGuard ? VpnProtocol.wireGuard : VpnProtocol.openVpn(transportProtocol)
        let vpnParam = VpnParamRequest()
        
        vpnParam.tech = isWireGuard ? .wg : .ovpn
        vpnParam.proto = userSetting?.appSettings?.settingVpn?.defaultProtocol ?? "tcp"
        vpnParam.dev = "tun"
        vpnParam.isHop = (params?.isHop ?? false) ? 1 : 0
        vpnParam.cybersec = 0
       
        
        switch connectType {
        case .quick:
            vpnParam.serverId = 14
        case let .serverId(id):
            vpnParam.serverId = id
        case let .countryId(id):
            vpnParam.countryId = id
        case let .cityId(id):
            vpnParam.cityId = id
        case let .lastSessionCode(code):
            vpnParam.prevSessionId = code
        }
        _ = APIServiceManager.shared.onRequestCert(param: vpnParam).subscribe{ event in
           
            switch event {
            case let .success(response):
                let strConfig = response.parseVpnConfig()
                let result = PrepareConnecitonStringResult(connectionString: strConfig, vpnProtocol: defaultTech)
                callback?(.success(result))
            case let .failure(e):
                print("[ERROR]: \(e)")
                callback?(.failure(e))
            }
        }
        
        
        
        
    }
    
    func disconnectLastSession(disconnectParam: DisconnectVPNParams?, callback: ((Result<Bool, Error>) -> Void)?) {
        
    }
    
}
