//
//  VPNResult.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct VPNResult: Codable {
    enum CodingKeys: String, CodingKey {
        case sessionId
        case server
        case connectionDetails
    }

    var sessionId: String?
    var server: VPNServer?
    var connectionDetails: VPNConnectionDetails?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId)
        server = try container.decodeIfPresent(VPNServer.self, forKey: .server)
        connectionDetails = try container.decodeIfPresent(VPNConnectionDetails.self, forKey: .connectionDetails)
    }
    
    func parseVpnConfig() -> String {
        guard let config = connectionDetails else {
            return ""
        }
        var stringData = "client"
        let spaceLine = "\r\n"
        stringData += spaceLine
        stringData += "dev " + (config.dev ?? "") + spaceLine
        stringData += "proto " + (config.proto ?? "") + spaceLine
        config.remote?.forEach {
            stringData += "remote " + $0 + spaceLine
        }
        stringData += "auth " + (config.auth ?? "") + spaceLine
        stringData += "auth-nocache " + (config.authNocache ?? "") + spaceLine
        stringData += "tls-version-min " + (config.tlsVersionMin ?? "") + spaceLine
        stringData += "tls-cipher " + (config.tlsCipher ?? "") + spaceLine
        stringData += "resolv-retry " + (config.resolvRetry ?? "") + spaceLine
        stringData += "nobind " + (config.nobind ?? "") + spaceLine
        stringData += "persist-key " + (config.persistKey ?? "") + spaceLine
        stringData += "mute-replay-warnings " + (config.muteReplayWarnings ?? "") + spaceLine
        stringData += "verb " + "\(config.verb)" + spaceLine
        stringData += "<ca>" + spaceLine + (config.ca?.replacingOccurrences(of: "\n", with: "\r\n") ?? "") + spaceLine + "</ca>" + spaceLine
        stringData += "<cert>" + spaceLine + (config.cert?.replacingOccurrences(of: "\n", with: "\r\n") ?? "") + spaceLine + "</cert>" + spaceLine
        stringData += "<key>" + spaceLine + (config.key?.replacingOccurrences(of: "\n", with: "\r\n") ?? "") + spaceLine + "</key>" + spaceLine
        stringData += "<tls-crypt>" + spaceLine + (config.tlsCrypt?.replacingOccurrences(of: "\n", with: "\r\n") ?? "") + spaceLine + "</tls-crypt>" + spaceLine
        return stringData
    }
}
