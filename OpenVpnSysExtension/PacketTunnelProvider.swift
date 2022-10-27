//
//  PacketTunnelProvider.swift
//  OpenVpnSysExtension
//
//  Created by macbook on 17/10/2022.
//
import NetworkExtension
import os.log
import TunnelKitManager
import TunnelKitOpenVPNAppExtension
enum VPNProtocol {
    case openVPN
    case wireGuard
}

class PacketTunnelProvider: NEPacketTunnelProvider {
    let userDefaults = UserDefaults(suiteName: CoreAppConstants.AppGroups.main)

    var type: VPNProtocol {
        return getProtocol()
    }

    private lazy var openVPNAdapter = OpenVPNTunnelAdapter(packetTunnelProvider: self)
    private lazy var wireguardAdapter = WireGuardTunnelAdapter(packetTunnelProvider: self)
     
    override func startTunnel(options: [String: NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        switch type {
        case .openVPN:
            return openVPNAdapter.startTunnel(options: options, completionHandler: completionHandler)
        case .wireGuard:
            return wireguardAdapter.startTunnel(options: options, completionHandler: completionHandler)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        switch type {
        case .openVPN:
            return openVPNAdapter.stopTunnel(with: reason, completionHandler: completionHandler)
        case .wireGuard:
            return wireguardAdapter.stopTunnel(with: reason, completionHandler: completionHandler)
        }
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        switch type {
        case .openVPN:
            return super.handleAppMessage(messageData, completionHandler: completionHandler)
        case .wireGuard:
            return wireguardAdapter.handleAppMessage(messageData, completionHandler: completionHandler)
        }
    }
    
    func getProtocol() -> VPNProtocol {
        let vpnProtocol = userDefaults?.string(forKey: "vpnProtocol") ?? "openVPN"
         
        os_log("%{public}s", log: OSLog(subsystem: "SysVPNIPC-OP", category: "IPC"), type: .default, "loadata \(vpnProtocol)")

        if vpnProtocol == "wireGuard" {
            return .wireGuard
        }
        return .openVPN
    }
}
