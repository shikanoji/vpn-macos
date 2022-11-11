//
//  SysVPNService.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 10/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

typealias SysVPNPrepareConnecitonStringCallback = (Result<PrepareConnecitonStringResult, Error>) -> Void

struct DisconnectVPNParams: Codable {
    var sessionId: String
    var disconnectedBy: String
}

struct PrepareConnecitonStringResult: Codable {
    var connectionString: String
    var vpnProtocol: VpnProtocol
    var disconnectParam: DisconnectVPNParams?
    var serverInfo: VPNServer
}

protocol SysVPNServiceFactory {
    func makeVpnService() -> SysVPNService
}

protocol SysVPNService {
    func prepareConection(connectType: ConnectionType, params: SysVPNConnectParams?, callback: SysVPNPrepareConnecitonStringCallback?)
    func disconnectLastSession(disconnectParam: DisconnectVPNParams?, callback: ((Result<Bool, Error>) -> Void)?)
}

class MockVPNService: SysVPNService {
    func prepareConection(connectType: ConnectionType, params: SysVPNConnectParams?, callback: SysVPNPrepareConnecitonStringCallback?) {
        let result = PrepareConnecitonStringResult(connectionString: MockVPNService.getText(), vpnProtocol: .openVpn(.udp), serverInfo: VPNServer())
        
        callback?(.success(result))
    }
    
    func disconnectLastSession(disconnectParam: DisconnectVPNParams?, callback: ((Result<Bool, Error>) -> Void)?) {}
    
    class func getText() -> String {
        if let filePath = Bundle.main.path(forResource: "demofile", ofType: "ovpn") {
            do {
                let contents = try String(contentsOfFile: filePath)
                return contents
            } catch {
                // contents could not be loaded
            }
        }
        
        return ""
    }
}
