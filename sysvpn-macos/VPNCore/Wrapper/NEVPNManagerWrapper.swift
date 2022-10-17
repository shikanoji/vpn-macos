//
//  NEVPNManagerWrapper.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//
 
import Foundation
import NetworkExtension

public protocol ProviderMessage: Equatable {
    var asData: Data { get }

    static func decode(data: Data) throws -> Self
}

public protocol ProviderRequest: ProviderMessage {
    associatedtype Response: ProviderMessage
}

public protocol ProviderMessageSender: AnyObject {
    func send<R>(_ message: R, completion: ((Result<R.Response, ProviderMessageError>) -> Void)?) where R: ProviderRequest
}

public enum ProviderMessageError: Error {
    case noDataReceived
    case decodingError
    case sendingError
    case unknownRequest
    case unknownResponse
    case remoteError(message: String)
}


public protocol NEVPNManagerWrapper: AnyObject {
    var vpnConnection: NEVPNConnectionWrapper { get }
    var protocolConfiguration: NEVPNProtocol? { get set }
    var isEnabled: Bool { get set }
    var isOnDemandEnabled: Bool { get set }
    var onDemandRules: [NEOnDemandRule]? { get set }
    func loadFromPreferences(completionHandler: @escaping (Error?) -> Void)
    func saveToPreferences(completionHandler: ((Error?) -> Void)?)
    func removeFromPreferences(completionHandler: ((Error?) -> Void)?)
}

extension NEVPNManager: NEVPNManagerWrapper { 
    public var vpnConnection: NEVPNConnectionWrapper {
        self.connection
    }
}

public protocol NEVPNManagerWrapperFactory {
    func makeNEVPNManagerWrapper() -> NEVPNManagerWrapper
}

public protocol NETunnelProviderManagerWrapper: NEVPNManagerWrapper {
}

extension NETunnelProviderManager: NETunnelProviderManagerWrapper {
}

public protocol NETunnelProviderManagerWrapperFactory {
    func makeNewManager() -> NETunnelProviderManagerWrapper
    func loadManagersFromPreferences(completionHandler: @escaping ([NETunnelProviderManagerWrapper]?, Error?) -> Void)
}

extension NETunnelProviderManagerWrapperFactory {
    func tunnelProviderManagerWrapper(forProviderBundleIdentifier bundleId: String, completionHandler: @escaping (NETunnelProviderManagerWrapper?, Error?) -> Void) {
        loadManagersFromPreferences { (managers, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            guard let managers = managers else {
                completionHandler(nil, SysVPNError.vpnManagerUnavailable)
                return
            }

            let vpnManager = managers.first(where: { (manager) -> Bool in
                return (manager.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == bundleId
            }) ?? self.makeNewManager()

            completionHandler(vpnManager, nil)
        }
    }
}

extension NETunnelProviderManager: NETunnelProviderManagerWrapperFactory {
    public func makeNewManager() -> NETunnelProviderManagerWrapper {
        NETunnelProviderManager()
    }

    public func loadManagersFromPreferences(completionHandler: @escaping ([NETunnelProviderManagerWrapper]?, Error?) -> Void) {
        Self.loadAllFromPreferences { managers, error in
            completionHandler(managers, error)
        }
    }
}

public protocol NEVPNConnectionWrapper {
    var vpnManager: NEVPNManagerWrapper { get }
    var status: NEVPNStatus { get }
    var connectedDate: Date? { get }

    func startVPNTunnel() throws
    func stopVPNTunnel()
}

extension NEVPNConnection: NEVPNConnectionWrapper {
    public var vpnManager: NEVPNManagerWrapper {
        self.manager
    }
}

public protocol NETunnelProviderSessionWrapper: NEVPNConnectionWrapper & ProviderMessageSender {
    func sendProviderMessage(_ messageData: Data, responseHandler: ((Data?) -> Void)?) throws
}

/// For `ProviderMessageSender`
extension NETunnelProviderSessionWrapper {
    public func send<R>(_ message: R, completion: ((Result<R.Response, ProviderMessageError>) -> Void)?) where R: ProviderRequest {
        send(message, maxRetries: 5, completion: completion)
    }

    private func send<R>(_ message: R, maxRetries: Int, completion: ((Result<R.Response, ProviderMessageError>) -> Void)?) where R: ProviderRequest {
        do {
            try sendProviderMessage(message.asData) { [weak self] maybeData in
                guard let data = maybeData else { 
                    guard maxRetries > 0 else {
                        completion?(.failure(.noDataReceived))
                        return
                    }

                    sleep(1)
                    self?.send(message, maxRetries: maxRetries - 1, completion: completion)
                    return
                }

                do {
                    let response = try R.Response.decode(data: data)
                    completion?(.success(response))
                } catch {
                    completion?(.failure(.decodingError))
                }
            }
        } catch {
           // log.error("Received error while attempting to send provider message: \(error)")
            completion?(.failure(.sendingError))
        }
    }
}

extension NETunnelProviderSession: NETunnelProviderSessionWrapper {
}
