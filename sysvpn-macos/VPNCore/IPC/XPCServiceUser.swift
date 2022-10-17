//
//  XPCServiceUser.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

class XPCServiceUser {
    private let machServiceName: String
    private let log: (String) -> Void

    private var currentConnection: NSXPCConnection? {
        willSet {
            if newValue == nil {
                currentConnection?.invalidate()
            }
        }
    }

    init(withExtension machServiceName: String, logger: @escaping (String) -> Void) {
        self.machServiceName = machServiceName
        self.log = logger
    }

    func getLogs(completionHandler: @escaping (Data?) -> Void) {
        guard let providerProxy = connection.remoteObjectProxyWithErrorHandler({ registerError in
            self.log("Failed to get remote object proxy \(self.machServiceName): \(String(describing: registerError))")
            self.currentConnection = nil
            completionHandler(nil)
        }) as? ProviderCommunication else {
            self.log("Failed to create a remote object proxy for the provider: \(machServiceName)")
            completionHandler(nil)
            return
        }

        providerProxy.getLogs(completionHandler)
    }
    

    // MARK: - Private

    private var connection: NSXPCConnection {
        guard currentConnection == nil else {
            return currentConnection!
        }

        let newConnection = NSXPCConnection(machServiceName: machServiceName, options: [])

        // The exported object is the delegate.
        newConnection.exportedInterface = NSXPCInterface(with: AppCommunication.self)
        newConnection.exportedObject = self

        // The remote object is the provider's IPCConnection instance.
        newConnection.remoteObjectInterface = NSXPCInterface(with: ProviderCommunication.self)

        currentConnection = newConnection
        newConnection.resume()

        return newConnection
    }
}

extension XPCServiceUser: AppCommunication {

}
