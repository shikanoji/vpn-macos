//
//  SysVPNProtocol.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 01/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
import NetworkExtension
import TunnelKitManager

protocol SysVPNGatewayProtocol: AnyObject {
    var connection: ConnectionStatus { get }
    static var connectionChanged: Notification.Name { get }
    static var activeServerTypeChanged: Notification.Name { get }
    static var needsReconnectNotification: Notification.Name { get }
    func autoConnect()
    func quickConnect()
    func quickConnectConnectionRequest() -> SysVPNConnectionRequest
    func connectTo(connectType: ConnectionType, params: SysVPNConnectParams?)
    func retryConnection()
    func connect(with request: SysVPNConnectionRequest)
    func stopConnecting(userInitiated: Bool)
    func disconnect()
    func disconnect(completion: @escaping () -> Void)
    func postConnectionInformation()
    var lastConnectionConiguration: ConnectionConfiguration? { get set }
}

protocol SysVPNnGatewayFactory {
    func makeVpnGateway() -> SysVPNGatewayProtocol
}

protocol SysVpnManagerConfiguration {
    var username: String { get }
    var password: String { get }
    var adapterTitle: String { get }
    var connection: String { get }
    var extra: NetworkExtensionExtra { get }
    var vpnProtocol: VpnProtocol { get }
    var passwordReference: Data { get }
}
 
enum VpnProviderManagerRequirement {
    case configuration
    case status
}

protocol VpnProtocolFactory {
    func create(_ configuration: SysVpnManagerConfiguration) throws -> NEVPNProtocol
    func vpnProviderManager(for requirement: VpnProviderManagerRequirement, completion: @escaping (NEVPNManagerWrapper?, Error?) -> Void)
    func logs(completion: @escaping (String?) -> Void)
}

protocol SysVPNManagerProtocol {
    var sessionStartTime: Double? {
        get
    }
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
    func prepareManagers(forSetup: Bool)
}

protocol SysVPNManagerFactory {
    func makeVpnManager() -> SysVPNManagerProtocol
}

class SysVPNConfiguration: SysVpnManagerConfiguration {
    var username: String
    var password: String
    var adapterTitle: String
    var connection: String
    var extra: NetworkExtensionExtra = .init()
    var vpnProtocol: VpnProtocol
    var passwordReference: Data
     
    init(username: String, password: String, adapterTitle: String, connection: String, vpnProtocol: VpnProtocol, passwordReference: Data) {
        self.username = username
        self.password = password
        self.adapterTitle = adapterTitle
        self.connection = connection
        self.vpnProtocol = vpnProtocol
        self.passwordReference = passwordReference
    }
}

struct SysVPNConnectParams: Codable {
    var isHop: Bool?
}

struct ConnectionConfiguration: Codable {
    var connectionDetermine: PrepareConnecitonStringResult
    var connectionParam: SysVPNConnectParams?
    var vpnProtocol: VpnProtocol
    var serverInfo: VPNServer
}
 
protocol SysVpnService {
    func prepareConection(connectType: ConnectionType, params: SysVPNConnectParams?)
}
