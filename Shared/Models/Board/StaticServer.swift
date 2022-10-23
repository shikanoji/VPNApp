//
//  StaticServer.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/02/2022.
//

import Foundation
import CoreGraphics

struct ServerStats: Codable {
    var rows: [StaticServer]
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case rows
        case count
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _value = try? values.decode([StaticServer].self, forKey: .rows) {
            rows = _value
        } else {
            rows = []
        }
        
        if let _value = try? values.decode(Int.self, forKey: .count) {
            count = _value
        } else {
            count = 0
        }
    }
}

struct StaticServer: Identifiable, Codable {
    var id: Int { serverId }
    var serverId: Int
    var countryId: Int?
    var countryName: String
    var latitude: String
    var longitude: String
    var x: CGFloat
    var y: CGFloat
    var flag: String
    var cityName: String
    var currentLoad: CGFloat
    var iso2: String
    var iso3: String
    var serverNumber: Int
    var score: Int
    
    enum CodingKeys: String, CodingKey {
        case serverId
        case countryId
        case countryName
        case latitude
        case longitude
        case flag
        case x
        case y
        case currentLoad
        case cityName
        case serverNumber
        case iso2
        case iso3
        case score
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _value = try? values.decode(Int.self, forKey: .score) {
            score = _value
        } else {
            score = 0
        }
        if let _value = try? values.decode(String.self, forKey: .iso2) {
            iso2 = _value
        } else {
            iso2 = ""
        }
        if let _value = try? values.decode(String.self, forKey: .iso3) {
            iso3 = _value
        } else {
            iso3 = ""
        }
        if let _serverNumber = try? values.decode(Int.self, forKey: .serverNumber) {
            serverNumber = _serverNumber
        } else {
            serverNumber = 0
        }
        if let _serverId = try? values.decode(Int.self, forKey: .serverId) {
            serverId = _serverId
        } else {
            serverId = 0
        }
        if let _countryId = try? values.decode(Int.self, forKey: .countryId) {
            countryId = _countryId
        } else {
            countryId = nil
        }
        if let _countryName = try? values.decode(String.self, forKey: .countryName) {
            countryName = _countryName
        } else {
            countryName = ""
        }
        if let _latitude = try? values.decode(String.self, forKey: .latitude) {
            latitude = _latitude
        } else {
            latitude = ""
        }
        if let _longitude = try? values.decode(String.self, forKey: .longitude) {
            longitude = _longitude
        } else {
            longitude = ""
        }
        if let _flag = try? values.decode(String.self, forKey: .flag) {
            flag = _flag
        } else {
            flag = ""
        }
        if let _x = try? values.decode(CGFloat.self, forKey: .x) {
            x = _x
        } else {
            x = 0
        }
        if let _y = try? values.decode(CGFloat.self, forKey: .y) {
            y = _y
        } else {
            y = 0
        }
        if let _currentLoad = try? values.decode(CGFloat.self, forKey: .currentLoad) {
            currentLoad = _currentLoad
        } else {
            currentLoad = 0
        }
        if let _cityName = try? values.decode(String.self, forKey: .cityName) {
            cityName = _cityName
        } else {
            cityName = ""
        }
    }
    
    init(serverId: Int = 0,
         countryName: String = "",
         cityName: String = "",
         subRegion: String = "",
         latitude: String = "",
         longitude: String = "",
         x: CGFloat = .zero,
         y: CGFloat = .zero,
         flag: String = "",
         currentLoad: CGFloat = 0,
         serverNumber: Int = 0,
         iso2: String = "",
         iso3: String = "",
         score: Int = 0) {
        self.serverId = serverId
        self.countryName = countryName
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.x = x
        self.y = y
        self.flag = flag
        self.currentLoad = currentLoad
        self.serverNumber = serverNumber
        self.iso2 = iso2
        self.iso3 = iso3
        self.score = score
    }
    
    func getTitleContentCell() -> String {
        var number = ""
        if serverNumber < 10 {
            number = "#00\(serverNumber)"
        } else if serverNumber >= 10 && serverNumber < 100 {
            number = "#0\(serverNumber)"
        } else {
            number = "#\(serverNumber)"
        }
        return countryName + " " + number
    }
    
    func getSubContentCell() -> String {
        return cityName
    }
}

extension StaticServer: Equatable {
    static func == (lhs: StaticServer, rhs: StaticServer) -> Bool {
        return lhs.serverId == rhs.serverId
    }
}

extension StaticServer {
    static let simple = [StaticServer()]
}
