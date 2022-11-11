//
//  VPNConnectionDetails.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct VPNConnectionDetails: Codable {
    enum CodingKeys: String, CodingKey {
        case resolvRetry = "resolv-retry"
        case proto
        case client
        case renegSec = "reneg-sec"
        case auth
        case nobind
        case tlsCrypt = "tls-crypt"
        case cipher
        case dev
        case remoteCertTls = "remote-cert-tls"
        case remote
        case remoteRandom = "remote-random"
        case persistKey = "persist-key"
        case cert
        case tlsVersionMin = "tls-version-min"
        case ca
        case tlsCipher = "tls-cipher"
        case key
        case verb
        case authNocache = "auth-nocache"
        case muteReplayWarnings = "mute-replay-warnings"
    }

    var resolvRetry: String?
    var proto: String?
    var client: String?
    var renegSec: Int?
    var auth: String?
    var nobind: String?
    var tlsCrypt: String?
    var cipher: String?
    var dev: String?
    var remoteCertTls: String?
    var remote: [String]?
    var remoteRandom: String?
    var persistKey: String?
    var cert: String?
    var tlsVersionMin: String?
    var ca: String?
    var tlsCipher: String?
    var key: String?
    var verb: Int?
    var authNocache: String?
    var muteReplayWarnings: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resolvRetry = try container.decodeIfPresent(String.self, forKey: .resolvRetry)
        proto = try container.decodeIfPresent(String.self, forKey: .proto)
        client = try container.decodeIfPresent(String.self, forKey: .client)
        renegSec = try container.decodeIfPresent(Int.self, forKey: .renegSec)
        auth = try container.decodeIfPresent(String.self, forKey: .auth)
        nobind = try container.decodeIfPresent(String.self, forKey: .nobind)
        tlsCrypt = try container.decodeIfPresent(String.self, forKey: .tlsCrypt)
        cipher = try container.decodeIfPresent(String.self, forKey: .cipher)
        dev = try container.decodeIfPresent(String.self, forKey: .dev)
        remoteCertTls = try container.decodeIfPresent(String.self, forKey: .remoteCertTls)
        remote = try container.decodeIfPresent([String].self, forKey: .remote)
        remoteRandom = try container.decodeIfPresent(String.self, forKey: .remoteRandom)
        persistKey = try container.decodeIfPresent(String.self, forKey: .persistKey)
        cert = try container.decodeIfPresent(String.self, forKey: .cert)
        tlsVersionMin = try container.decodeIfPresent(String.self, forKey: .tlsVersionMin)
        ca = try container.decodeIfPresent(String.self, forKey: .ca)
        tlsCipher = try container.decodeIfPresent(String.self, forKey: .tlsCipher)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        verb = try container.decodeIfPresent(Int.self, forKey: .verb)
        authNocache = try container.decodeIfPresent(String.self, forKey: .authNocache)
        muteReplayWarnings = try container.decodeIfPresent(String.self, forKey: .muteReplayWarnings)
    }
}
