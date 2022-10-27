//
//  PacketTunnelProvider.swift
//  OpenVpnAppExtension
//
//  Created by macbook on 21/10/2022.
//

import NetworkExtension
import os.log
import TunnelKitOpenVPNAppExtension


class PacketTunnelProvider: NEPacketTunnelProvider {
   
    private lazy var openVPNAdapter = OpenVPNTunnelAdapter(packetTunnelProvider: self)
 
    override func startTunnel(options: [String: NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        return openVPNAdapter.startTunnel(options: options, completionHandler: completionHandler)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        return openVPNAdapter.stopTunnel(with: reason, completionHandler: completionHandler)
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        return super.handleAppMessage(messageData, completionHandler: completionHandler)
    }
 
}
