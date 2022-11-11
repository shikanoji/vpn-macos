//
//  IpInfo.swift
//
//  Created by doragon on 17/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AppSettingIpInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case ip
        case latitude
        case isp
        case proxyCountryName
        case proxyType
        case isProxy
        case countryCode
        case proxyCountryCode
        case city
        case countryName
        case longitude
    }

    var ip: String?
    var latitude: Double?
    var isp: String?
    var proxyCountryName: String?
    var proxyType: String?
    var isProxy: Int?
    var countryCode: String?
    var proxyCountryCode: String?
    var city: String?
    var countryName: String?
    var longitude: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ip = try container.decodeIfPresent(String.self, forKey: .ip)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        isp = try container.decodeIfPresent(String.self, forKey: .isp)
        proxyCountryName = try container.decodeIfPresent(String.self, forKey: .proxyCountryName)
        proxyType = try container.decodeIfPresent(String.self, forKey: .proxyType)
        isProxy = try container.decodeIfPresent(Int.self, forKey: .isProxy)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        proxyCountryCode = try container.decodeIfPresent(String.self, forKey: .proxyCountryCode)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
    }
}
