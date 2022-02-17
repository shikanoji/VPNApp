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
    var countryId: Int
    var name = ""
    var latitude = ""
    var longitude = ""
    var x: CGFloat = .zero
    var y: CGFloat = .zero
    var flag: String = ""
    
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
        
        serverId = try values.decode(Int.self, forKey: .serverId)
        countryId = try values.decode(Int.self, forKey: .countryId)
        name = try values.decode(String.self, forKey: .name)
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
        flag = try values.decode(String.self, forKey: .flag)
        x = try values.decode(CGFloat.self, forKey: .x)
        y = try values.decode(CGFloat.self, forKey: .y)
    }
    
    init(serverId: Int = 0,
         countryId: Int = 0,
         name: String = "",
         latitude: String = "",
         longitude: String = "",
         x: CGFloat = .zero,
         y: CGFloat = .zero,
         flag: String = "") {
        self.serverId = serverId
        self.countryId = countryId
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.x = x
        self.y = y
        self.flag = flag
    }
}

extension StaticServer: Equatable {
    static func == (lhs: StaticServer, rhs: StaticServer) -> Bool {
        return lhs.serverId == rhs.serverId
    }
}
