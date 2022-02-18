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
    var name: String
    var latitude: String
    var longitude: String
    var x: CGFloat
    var y: CGFloat
    var flag: String
    
    enum CodingKeys: String, CodingKey {
        case serverId
        case countryId
        case name
        case latitude
        case longitude
        case flag
        case x
        case y
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
        if let _name = try? values.decode(String.self, forKey: .name){
            self.name = _name
        } else {
            self.name = ""
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
    }
}

extension StaticServer: Equatable {
    static func == (lhs: StaticServer, rhs: StaticServer) -> Bool {
        return lhs.serverId == rhs.serverId
    }
}
