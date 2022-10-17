//
//  OSExtensionManager.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 17/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//


 

import Foundation
import SystemExtensions
import os.log
class OSExtensionManager : NSObject {
    static let shared = OSExtensionManager()
    
    func getExtensionBundle (_ tunnel: String) -> Bundle? {
        let extensionsDirectoryURL = URL(fileURLWithPath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
        let extensionURLs: [URL]
        do {
            extensionURLs = try FileManager.default.contentsOfDirectory(at: extensionsDirectoryURL,
                                                                        includingPropertiesForKeys: nil,
                                                                        options: .skipsHiddenFiles)
        } catch let error {
            fatalError("Failed to get the contents of \(extensionsDirectoryURL.absoluteString): \(error.localizedDescription)")
        }

       /* /*print(extensionURLs.first )
    
        guard let extensionURL = extensionURLs[1] else {
            fatalError("Failed to find any system extensions")
        }
*/
        let extensionURL = extensionURLs[1]
        print( extensionURL )
        guard let extensionBundle = Bundle(url: extensionURL) else {
            fatalError("Failed to create a bundle with URL \(extensionURL.absoluteString)")
        }*/
        
        guard let extensionURL = extensionURLs.first(where: { $0.absoluteString.contains(tunnel) }) else {
            return nil
        }
        
        guard let extensionBundle = Bundle(url: extensionURL) else {
            return nil
        }
        
        return extensionBundle
        
    }
     
     func startExtension() {
         if let extensionIdentifier = getExtensionBundle(CoreAppConstants.NetworkExtensions.openVpn)?.bundleIdentifier {
             let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
             activationRequest.delegate = self
             OSSystemExtensionManager.shared.submitRequest(activationRequest)
        }
        if let extensionIdentifier = getExtensionBundle(CoreAppConstants.NetworkExtensions.wireguard)?.bundleIdentifier {
             let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionIdentifier, queue: .main)
             activationRequest.delegate = self
             OSSystemExtensionManager.shared.submitRequest(activationRequest)
        }
    }
}


extension OSExtensionManager: OSSystemExtensionRequestDelegate {

    // MARK: OSSystemExtensionActivationRequestDelegate

    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {

        guard result == .completed else {
            os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "Unexpected result \(result.rawValue) for system extension request")

            return
        }
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {

       // os_log("System extension request failed: %@", error.localizedDescription)
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "System extension request failed: \(error.localizedDescription)")
    }

    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {

      //  os_log("Extension %@ requires user approval", request.identifier)
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "Extension %@ requires user approval \(request.identifier)")
    }

    func request(_ request: OSSystemExtensionRequest,
                 actionForReplacingExtension existing: OSSystemExtensionProperties,
                 withExtension extension: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {

        os_log("Replacing extension %@ version %@ with version %@", request.identifier, existing.bundleShortVersion, `extension`.bundleShortVersion)
        return .replace
    }
}
