//
//  CountryModel.swift
//  sysvpn-macos
//
//  Created by doragon on 05/10/2022.
//

import Foundation
import SwiftyJSON

class CountryResponse: BaseModel {
    var availableCountries: [CountryModel]?
    var recommendedCountries: [CountryModel]?
    var staticServers: [StaticServerModel]?
    
    var settings: OderModel?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        availableCountries = json[JSONCountryKey.availableCountries].arrayValue.map { data in
            return CountryModel(json: data)!
        }
        
        recommendedCountries = json[JSONCountryKey.recommendedCountries].arrayValue.map { data in
            return CountryModel(json: data)!
        }
        
        staticServers = json[JSONCountryKey.staticServers].arrayValue.map { data in
            return StaticServerModel(json: data)!
        }
        
        settings = OderModel(json: json[JSONCountryKey.settings])
    }
}

class CountryModel: BaseModel {
    var id: Int?
    var name: String?
    var iso2: String?
    var iso3: String?
    var region: String?
    var subRegion: String?
    var latitude: String?
    var longitude: String?
    var flag: String?
    var city: [CityModel]?
    var x: Double?
    var y: Double?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        id = json[JSONCountryKey.id].int
        name = json[JSONCountryKey.name].string
        iso2 = json[JSONCountryKey.iso2].string
        iso3 = json[JSONCountryKey.iso3].string
        region = json[JSONCountryKey.region].string
        subRegion = json[JSONCountryKey.subRegion].string
        latitude = json[JSONCountryKey.latitude].string
        longitude = json[JSONCountryKey.longitude].string
        flag = json[JSONCountryKey.flag].string
        x = json[JSONCountryKey.x].double
        y = json[JSONCountryKey.y].double
        city = json[JSONCountryKey.city].arrayValue.map { data in
            return CityModel(json: data)!
        }
    }
}

class CityModel: BaseModel {
    var id: Int?
    var name: String?
    var latitude: String?
    var longitude: String?
    var countryId: Int?
    var x: Double?
    var y: Double?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        id = json[JSONCountryKey.id].int
        name = json[JSONCountryKey.name].string
        latitude = json[JSONCountryKey.latitude].string
        longitude = json[JSONCountryKey.longitude].string
        countryId = json[JSONCountryKey.countryId].int
        x = json[JSONCountryKey.x].double
        y = json[JSONCountryKey.y].double
    }
}

class OderModel: BaseModel {
    var fields: [String]?
    var direction: String?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        fields = json[JSONCountryKey.fields].arrayObject?.map { str in
            return str
        } as? [String]
        direction = json[JSONCountryKey.direction].string
    }
}

class StaticServerModel: BaseModel {
    var latitude: String?
    var longitude: String?
    var countryId: Int?
    var x: Double?
    var y: Double?
    var iso2: String?
    var iso3: String?
    var flag: String?
    var serverId: Int?
    var currentLoad: Int?
    var serverNumber: Int?
    var countryName: String?
    var cityName: String?
    
    required convenience init?(json: JSON?) {
        guard let _json = json else { return nil }
        self.init()
        parseJson(_json)
    }
    
    func parseJson(_ json: JSON) {
        latitude = json[JSONCountryKey.latitude].string
        longitude = json[JSONCountryKey.longitude].string
        countryId = json[JSONCountryKey.countryId].int
        x = json[JSONCountryKey.x].double
        y = json[JSONCountryKey.y].double
        flag = json[JSONCountryKey.flag].string
        iso2 = json[JSONCountryKey.iso2].string
        iso3 = json[JSONCountryKey.iso3].string
        serverId = json[JSONCountryKey.serverId].int
        currentLoad = json[JSONCountryKey.currentLoad].int
        serverNumber = json[JSONCountryKey.serverNumber].int
        countryName = json[JSONCountryKey.countryName].string
        cityName = json[JSONCountryKey.cityName].string
    }
}

struct JSONCountryKey {
    static let id = "id"
    static let name = "name"
    static let iso2 = "iso2"
    static let iso3 = "iso3"
    static let city = "city"
    static let region = "region"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let subRegion = "subRegion"
    static let flag = "flag"
    static let countryId = "countryId"
    static let x = "x"
    static let y = "y"
    static let availableCountries = "availableCountries"
    static let settings = "settings"
    static let order = "order"
    static let fields = "fields"
    static let direction = "direction"
    static let recommendedCountries = "recommendedCountries"
    static let staticServers = "staticServers"
    static let serverId = "serverId"
    static let cityName = "cityName"
    static let currentLoad = "currentLoad"
    static let serverNumber = "serverNumber"
    static let countryName = "countryName"
}
