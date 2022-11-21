//
//  SystemNetworkingMonitor.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 30/09/2022.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class SystemDataUsage {
    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"
    private static var vpnInterfaces: [String]?
    static var lastestVpnUsageInfo: SingleDataUsageInfo = .init(received: 0, sent: 0)
    class func getDataUsage() -> DataUsageInfo {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = DataUsageInfo()
        
        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let addr = ifaddr {
            guard let info = getDataUsageInfo(from: addr) else {
                ifaddr = addr.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info)
            ifaddr = addr.pointee.ifa_next
        }
        
        freeifaddrs(ifaddr)
        
        return dataUsageInfo
    }
     
    class func vpnDataUsageInfo() -> SingleDataUsageInfo {
        var dataUsageInfo = SingleDataUsageInfo()
        var vpnInterface: [String] = []
        
        
        var utunAddr: ifaddrs = ifaddrs()
        if getSysVpnProto(&utunAddr) == 1 {
            let name: String = String(cString: utunAddr.ifa_name) 
            print("Interface name: \(name)")
            var networkData: UnsafeMutablePointer<if_data>?
            networkData = unsafeBitCast(utunAddr.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                let send = UInt64(data.pointee.ifi_obytes)
                let received = UInt64(data.pointee.ifi_ibytes)
                dataUsageInfo.received += received
                dataUsageInfo.sent += send
            }
        } else {
            if let interfaces = vpnInterfaces {
                vpnInterface = interfaces
            } else {
                 
                if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
                   let scopes = settings["__SCOPED__"] as? [String: Any] {
                    for (key, _) in scopes {
                        if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                            vpnInterface.append(key)
                        }
                    }
                }
            }
            
             
            if vpnInterfaces == nil && !vpnInterface.isEmpty {
                vpnInterfaces = vpnInterface
            }
            
        
            var ifaddr: UnsafeMutablePointer<ifaddrs>?
            guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
            while let pointer = ifaddr {
                let name: String! = String(cString: pointer.pointee.ifa_name)
                let addr = pointer.pointee.ifa_addr.pointee
                
                guard addr.sa_family == UInt8(AF_LINK) else {
                    ifaddr = pointer.pointee.ifa_next
                    continue
                }
                if !vpnInterface.contains(name) {
                    ifaddr = pointer.pointee.ifa_next
                    continue
                }
               
                var networkData: UnsafeMutablePointer<if_data>?
                networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                if let data = networkData {
                    
                    let send = UInt64(data.pointee.ifi_obytes)
                    let received = UInt64(data.pointee.ifi_ibytes)
                    dataUsageInfo.received += received
                    dataUsageInfo.sent += send
                    
                }
                ifaddr = pointer.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
           
            
        }
        
        
        lastestVpnUsageInfo = dataUsageInfo
        return dataUsageInfo
    }
    
    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        return dataUsageInfo(from: pointer, name: name)
    }
    
    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>?
        var dataUsageInfo = DataUsageInfo()
        
        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wifiSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wifiReceived += UInt64(data.pointee.ifi_ibytes)
            }
            
        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wirelessWanDataSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wirelessWanDataReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        return dataUsageInfo
    }
}

struct DataUsageInfo {
    var wifiReceived: UInt64 = 0
    var wifiSent: UInt64 = 0
    var wirelessWanDataReceived: UInt64 = 0
    var wirelessWanDataSent: UInt64 = 0
    
    mutating func updateInfoByAdding(_ info: DataUsageInfo) {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}

struct SingleDataUsageInfo {
    var received: UInt64 = 0
    var sent: UInt64 = 0
    
    mutating func updateInfoByAdding(_ info: SingleDataUsageInfo) {
        received += info.received
        sent += info.sent
    }
    
    func displayString(for rate: UInt64) -> String {
        let rateString: String
        
        switch rate {
        case let rate where rate >= UInt64(pow(1024.0, 3)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 3))) GB"
        case let rate where rate >= UInt64(pow(1024.0, 2)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 2))) MB"
        case let rate where rate >= 1024:
            rateString = "\(String(format: "%.1f", Double(rate) / 1024.0)) KB"
        default:
            rateString = "\(String(format: "%.1f", Double(rate))) B"
        }
        
        return rateString
    }
}
