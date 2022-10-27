//
//  XPCBaseService.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation
class XPCBaseService: NSObject {
    private let machServiceName: String
    let log: (String) -> Void

    private var currentConnection: NSXPCConnection?
    private var listener: NSXPCListener?

    init(withExtension machServiceName: String, logger: @escaping (String) -> Void) {
        self.machServiceName = machServiceName
        log = logger
    }

    func startListener() {
        log("Starting XPC listener for mach service \(machServiceName)")

        let newListener = NSXPCListener(machServiceName: machServiceName)
        newListener.delegate = self
        newListener.resume()
        listener = newListener
    }
}

extension XPCBaseService: ProviderCommunication {
    func getProtocol(_ completion: @escaping (String) -> Void) {
        log("This is just a placeholder! Add `getProtocol` in each implementation.")
    }
    
    func request(request: [String: NSObject], completionHandler: @escaping ([String: NSObject]) -> Void) {
        log("This is just a placeholder! Add `request` in each implementation.")
    }
    
    func getLogs(_: @escaping (Data?) -> Void) {
        log("This is just a placeholder! Add `getLogs` in each implementation.")
    }
    
    func setProtocol(vpnProtocol: String) {
        log("This is just a placeholder! Add `setProtocol` in each implementation.")
    }
}

extension XPCBaseService: NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        // Check the code signature of the remote endpoint to avoid tampering.
        let pid = newConnection.processIdentifier
        let auditToken = newConnection.auditToken
        log("XPC  audit token \(auditToken)")
        do {
            let matches = try CodeSignatureComparitor.codeSignatureMatches(auditToken: auditToken)
            #if DEBUG
                if !matches {
                    log("Code signature of pid \(pid) does not match. Proceeding anyway (debug build).")
                }
            #else
                guard matches else {
                    log("Refusing XPC connection with pid \(pid): code signature does not match")
                    return false
                }
            #endif
        } catch {
            log("Code signing error occurred while verifying pid \(pid): \(String(describing: error))")

            #if !DEBUG
                log("Rejecting XPC connection.")
                return false
            #endif
        }

        // The exported object is this IPCConnection instance.
        newConnection.exportedInterface = NSXPCInterface(with: ProviderCommunication.self)
        newConnection.exportedObject = self

        // The remote object is the delegate of the app's IPCConnection instance.
        newConnection.remoteObjectInterface = NSXPCInterface(with: AppCommunication.self)

        newConnection.invalidationHandler = {
            self.log("XPC invalidated for mach service \(self.machServiceName)")
            self.currentConnection = nil
        }

        newConnection.interruptionHandler = {
            self.log("XPC connection interrupted for mach service \(self.machServiceName)")
            self.currentConnection = nil
        }

        if currentConnection != nil {
            // self.currentConnection?.invalidate()
            currentConnection = nil
        }

        currentConnection = newConnection
        newConnection.resume()

        return true
    }
}
