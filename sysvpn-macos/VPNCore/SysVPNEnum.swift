//
//  SysVpnEnum.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 01/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation


enum ConnectionStatus {
    
    case disconnected
    case connecting
    case connected
    case disconnecting
    
    static func forAppState(_ appState: AppState) -> ConnectionStatus {
        switch appState {
        case .disconnected, .aborted, .error:
            return .disconnected
        case .preparingConnection, .connecting:
            return .connecting
        case .connected:
            return .connected
        case .disconnecting:
            return .disconnecting
        }
    }
}


enum ConnectionType {
    case serverId(id: String)
    case countryId(id: String)
    case cityId(id: String)
    case lastSessionCode(code: String)
    case quick
}

protocol VpnManagerProtocol {

    var stateChanged: (() -> Void)? { get set }
    var state: VpnState { get }
    var localAgentStateChanged: ((Bool?) -> Void)? { get set }
    var isLocalAgentConnected: Bool? { get }
    var currentVpnProtocol: VpnProtocol? { get }

    func appBackgroundStateDidChange(isBackground: Bool)
    func isOnDemandEnabled(handler: @escaping (Bool) -> Void)
    func setOnDemand(_ enabled: Bool)
    func disconnectAnyExistingConnectionAndPrepareToConnect(with configuration: SysVpnManagerConfiguration, completion: @escaping () -> Void)
    func disconnect(completion: @escaping () -> Void)
    func connectedDate(completion: @escaping (Date?) -> Void)
    func refreshState()
    func refreshManagers()
    func removeConfigurations(completionHandler: ((Error?) -> Void)?)
 
    func whenReady(queue: DispatchQueue, completion: @escaping () -> Void)
 
  
}

enum OpenVpnTransport : String, Codable {
    
    case tcp = "tcp"
    case udp = "udp"

    private static var defaultValue = OpenVpnTransport.tcp
    
    private struct CoderKey {
        static let transportProtocol = "transportProtocol"
    }
    
    public init(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeObject(forKey: CoderKey.transportProtocol) as? Data else {
            self = .defaultValue
            return
        }
        switch data[0] {
        case 0:
            self = .tcp
        case 1:
            self = .udp
        default:
            self = .defaultValue
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        var data = Data(count: 1)
        switch self {
        case .tcp:
            data[0] = 0
        case .udp:
            data[0] = 1
        }
        aCoder.encode(data, forKey: CoderKey.transportProtocol)
    }
}
enum VpnProtocol : Codable {
    enum Key: CodingKey {
        case rawValue
        case transportProtocol
    }
    case openVpn (_ transport: OpenVpnTransport)
    case wireGuard
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        switch rawValue {
        case 1:
            let transportProtocol = try container.decode(OpenVpnTransport.self, forKey: .transportProtocol)
            self = .openVpn(transportProtocol)
        case 2:
            self = .wireGuard
        default:
            self = .openVpn(.udp)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .openVpn(let transportProtocol):
            try container.encode(1, forKey: .rawValue)
            try container.encode(transportProtocol, forKey: .transportProtocol)
        case .wireGuard:
            try container.encode(2, forKey: .rawValue)
        }
    }
}

extension VpnProtocol: Equatable {
    
}
