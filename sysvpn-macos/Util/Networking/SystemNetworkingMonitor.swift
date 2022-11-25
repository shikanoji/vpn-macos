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
    static var hadCanGetAppNetworkInterface = false
    static var canGetAppNetworkInterface = false {
        didSet {
            if canGetAppNetworkInterface {
                hadCanGetAppNetworkInterface = true
            }
        }
    }

    static var canGetSystemVpnInterface = false
    
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
    
    class func mayBeVPNInterface(name: String) -> Bool {
        return name.contains("tap") || name.contains("tun") || name.contains("ppp") || name.contains("ipsec")
    }
    
    private class func _allVpnDataUsageInfo() -> SingleDataUsageInfo {
        var dataUsageInfo = SingleDataUsageInfo()
        var canGetData = false
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let pointer = ifaddr {
            let name: String! = String(cString: pointer.pointee.ifa_name)
             
            let addr = pointer.pointee.ifa_addr.pointee
            
            guard addr.sa_family == UInt8(AF_LINK) else {
                ifaddr = pointer.pointee.ifa_next
                continue
            }
            
            if !mayBeVPNInterface(name: name) {
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
            canGetData = true
        }
        canGetSystemVpnInterface = canGetData
        freeifaddrs(ifaddr)
        return dataUsageInfo
    }
    
    private class func _appVpnDataUsageInfo() -> SingleDataUsageInfo {
        var dataUsageInfo = SingleDataUsageInfo()
        var utunAddr = ifaddrs()
       
        if get_sys_vpn_ifdv(&utunAddr) == 1 {
            let name = String(cString: utunAddr.ifa_name)
            if !mayBeVPNInterface(name: name) {
                canGetAppNetworkInterface = false
                return _allVpnDataUsageInfo()
            }
            
            var networkData: UnsafeMutablePointer<if_data>?
            networkData = unsafeBitCast(utunAddr.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                let send = UInt64(data.pointee.ifi_obytes)
                let received = UInt64(data.pointee.ifi_ibytes)
                dataUsageInfo.received += received
                dataUsageInfo.sent += send
            }
            canGetAppNetworkInterface = true
            canGetSystemVpnInterface = true
        } else {
            canGetAppNetworkInterface = false
            dataUsageInfo = _allVpnDataUsageInfo()
        }
        return dataUsageInfo
    }
     
    class func vpnDataUsageInfo() -> SingleDataUsageInfo {
        let dataUsageInfo = _appVpnDataUsageInfo()
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
