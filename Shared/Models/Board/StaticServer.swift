//
//  StaticServer.swift
//  SysVPN
//
//  Created by Da Phan Van on 17/02/2022.
//

import Foundation
import CoreGraphics

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
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _serverId = try? values.decode(Int.self, forKey: .serverId){
            self.serverId = _serverId
        } else {
            self.serverId = 0
        }
        if let _countryId = try? values.decode(Int.self, forKey: .countryId){
            self.countryId = _countryId
        } else {
            self.countryId = nil
        }
        if let _countryName = try? values.decode(String.self, forKey: .countryName){
            self.countryName = _countryName
        } else {
            self.countryName = ""
        }
        if let _latitude = try? values.decode(String.self, forKey: .latitude){
            self.latitude = _latitude
        } else {
            self.latitude = ""
        }
        if let _longitude = try? values.decode(String.self, forKey: .longitude){
            self.longitude = _longitude
        } else {
            self.longitude = ""
        }
        if let _flag = try? values.decode(String.self, forKey: .flag){
            self.flag = _flag
        } else {
            self.flag = ""
        }
        if let _x = try? values.decode(CGFloat.self, forKey: .x){
            self.x = _x
        } else {
            self.x = 0
        }
        if let _y = try? values.decode(CGFloat.self, forKey: .y){
            self.y = _y
        } else {
            self.y = 0
        }
        if let _currentLoad = try? values.decode(CGFloat.self, forKey: .currentLoad){
            self.currentLoad = _currentLoad
        } else {
            self.currentLoad = 0
        }
        if let _cityName = try? values.decode(String.self, forKey: .cityName){
            self.cityName = _cityName
        } else {
            self.cityName = ""
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
         currentLoad: CGFloat = 0) {
        self.serverId = serverId
        self.countryName = countryName
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.x = x
        self.y = y
        self.flag = flag
        self.currentLoad = currentLoad
    }
    
    func getSubContentCell() -> String {
        return cityName + " #\(serverId)"
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