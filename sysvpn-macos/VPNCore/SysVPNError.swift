//
//  SysVPNError.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation

public enum SysVPNError: Error {
    // Hash pwd part
    case modulusSignature
    case generateSrp
    case hashPassword
    case fetchSession
    
    // VPN properties
    case vpnProperties
    
    // Decode
    case decode(location: String)
    
    // Connections
    case connectionFailed
    case vpnManagerUnavailable
    case removeVpnProfileFailed
    case tlsInitialisation
    case tlsServerVerification
    
    // Keychain
    case keychainWriteFailed
    
    // User
    case subuserWithoutSessions
}
