//
//  DeviceOnline.swift
//  SysVPN
//
//  Created by Da Phan Van on 18/01/2022.
//

import Foundation
import SwiftUI

struct DeviceOnline: Codable, Identifiable {
    var id: String
    var name: String
    var active: Bool
    var ip: String
    var location: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case active
        case ip
        case location
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        active = (try values.decode(Int.self, forKey: .active) == 1)
        ip = try values.decode(String.self, forKey: .ip)
        location = try values.decode(String.self, forKey: .location)
    }
    
    init(id: String, name: String, active: Bool, ip: String,
         location: String) {
        self.name = name
        self.id = id
        self.active = active
        self.ip = ip
        self.location = location
    }
    
    static func example1() -> DeviceOnline {
        return DeviceOnline(id: "0", name: "iPhone 13 Promax", active: true, ip: "168.362.3.82.2", location: "Ha Noi, Viet Nam")
    }
    
    static func exampleList() -> [DeviceOnline] {
        return [
            DeviceOnline(id: "0", name: "iPhone 13 Promax", active: true, ip: "168.362.3.82.2", location: "Ha Noi, Viet Nam"),
            DeviceOnline(id: "1", name: "macOs Monterey", active: true, ip: "192.362.3.82.2", location: "Ha Noi, Viet Nam"),
            DeviceOnline(id: "2", name: "Samsung Note 20 Ultra", active: false, ip: "122.362.3.82.2", location: "Ha Noi, Viet Nam"),
            DeviceOnline(id: "3", name: "Huawei X20", active: false, ip: "122.362.3.82.2", location: "Ha Noi, Viet Nam"),
            DeviceOnline(id: "4", name: "RedMi Pro 5", active: false, ip: "122.362.3.82.2", location: "Ha Noi, Viet Nam")
        ]
    }
}
