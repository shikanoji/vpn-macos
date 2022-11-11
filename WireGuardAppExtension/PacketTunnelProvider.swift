//
//  PacketTunnelProvider.swift
//  WireGuardAppExtension
//
//  Created by macbook on 21/10/2022.
//
import NetworkExtension
import os.log
import TunnelKitWireGuardAppExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    let userDefaultsShared = UserDefaults(suiteName: CoreAppConstants.AppGroups.main)
    private lazy var wireguardAdapter = WireGuardTunnelAdapter(packetTunnelProvider: self)
     
    override func startTunnel(options: [String: NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        return wireguardAdapter.startTunnel(options: options, completionHandler: completionHandler)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        return wireguardAdapter.stopTunnel(with: reason, completionHandler: completionHandler)
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        return wireguardAdapter.handleAppMessage(messageData, completionHandler: completionHandler)
    }
   
    override func setTunnelNetworkSettings(_ tunnelNetworkSettings: NETunnelNetworkSettings?, completionHandler: ((Error?) -> Void)? = nil) {
        if let setting = tunnelNetworkSettings as? NEPacketTunnelNetworkSettings {
            if setting.ipv4Settings == nil {
                setting.ipv4Settings = NEIPv4Settings(addresses: [], subnetMasks: [])
            }
                
            let ips = ((userDefaultsShared?.array(forKey: "server_ips"))?.map { ip in
                return NEIPv4Route(destinationAddress: ip as! String, subnetMask: "255.255.255.255")
            }) ?? []
            setting.ipv4Settings?.excludedRoutes = ips
        }
        
        super.setTunnelNetworkSettings(tunnelNetworkSettings, completionHandler: completionHandler)
    }
}
