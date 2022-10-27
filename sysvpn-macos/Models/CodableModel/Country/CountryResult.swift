//
//  CountryResult.swift
//
//  Created by doragon on 07/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

struct CountryResult: Codable {
    enum CodingKeys: String, CodingKey {
        case availableCountries
        case settings
        case recommendedCountries
        case staticServers
    }

    var availableCountries: [CountryAvailables]?
    var settings: CountrySettings?
    var recommendedCountries: [CountryAvailables]?
    var staticServers: [CountryStaticServers]?
    var recentCountries: [CountryAvailables]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        availableCountries = try container.decodeIfPresent([CountryAvailables].self, forKey: .availableCountries)
        settings = try container.decodeIfPresent(CountrySettings.self, forKey: .settings)
        recommendedCountries = try container.decodeIfPresent([CountryAvailables].self, forKey: .recommendedCountries)
        staticServers = try container.decodeIfPresent([CountryStaticServers].self, forKey: .staticServers)
    }
    
    func saveListCountry() {
        saveFile(fileName: .keySaveCountry)
    }
    
    static func getListCountry() -> CountryResult? {
        return CountryResult.readFile(fileName: .keySaveCountry) as? CountryResult
    }
}
