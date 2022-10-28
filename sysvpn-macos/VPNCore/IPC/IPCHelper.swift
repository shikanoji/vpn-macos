//
//  IPCHelper.swift
//  macOS
//
//  Created by Jaroslav on 2021-07-30.
//  Copyright © 2021 Proton Technologies AG. All rights reserved.
//

import Foundation

class IPCHelper {
    static func extensionMachServiceName(from bundle: Bundle) -> String {
        guard let networkExtensionKeys = bundle.object(forInfoDictionaryKey: "NetworkExtension") as? [String: Any],
              let machServiceName = networkExtensionKeys["NEMachServiceName"] as? String else {
            fatalError("Mach service name is missing from the Info.plist")
        }
        return machServiceName
    }
    
    static func urlToIPGetHostByName(hostname: String) -> [String] {

        var ipList: [String] = []

       

        guard let host = hostname.withCString({gethostbyname($0)}) else {

            return ipList
        }

        guard host.pointee.h_length > 0 else {

            return ipList
        }

        var index = 0

        while host.pointee.h_addr_list[index] != nil {

            var addr: in_addr = in_addr()

            memcpy(&addr.s_addr, host.pointee.h_addr_list[index], Int(host.pointee.h_length))

            guard let remoteIPAsC = inet_ntoa(addr) else {

                return ipList
            }

            ipList.append(String.init(cString: remoteIPAsC))

            index += 1
        }

        return ipList
    }
}
