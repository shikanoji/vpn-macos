//
//  PacketTunnelProvider.swift
//  WireGuardAppExtension
//
//  Created by macbook on 21/10/2022.
//
import NetworkExtension
import TunnelKitWireGuardAppExtension
import os.log

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
                
                let ips =  ((userDefaultsShared?.array(forKey: "test"))?.map { ip in
                    return NEIPv4Route(destinationAddress: ip as! String, subnetMask: "255.255.255.255")
                }) ?? []
                
                os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC", category: "IPC"), type: .default, "setup network \(ips.count)")
                
                //ips.append(.init(destinationAddress: "10.40.46.1", subnetMask: "255.255.255.255"))
               
                setting.ipv4Settings?.excludedRoutes = ips
            }
        
        super.setTunnelNetworkSettings(tunnelNetworkSettings, completionHandler: completionHandler)
        
    }
}
