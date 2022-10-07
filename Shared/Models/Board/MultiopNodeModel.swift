//
//  MutilhopModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 12/06/2022.
//

import Foundation

struct MultiopNodeModel: Codable {
    var serverId: Int?
    var country: Node?
    var city: Node?
    
    enum CodingKeys: String, CodingKey {
        case serverId
        case country = "country"
        case city = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _serverId = try? values.decode(Int.self, forKey: .serverId) {
            serverId = _serverId
        } else {
            serverId = nil
        }
        
        if let _node = try? values.decode(Node.self, forKey: .country) {
            country = _node
        } else {
            country = nil
        }
        
        country?.isCity = false
        
        if let _node = try? values.decode(Node.self, forKey: .city) {
            city = _node
        } else {
            city = nil
        }
        
        city?.isCity = true
    }
}

struct MultihopModel: Codable, Identifiable {
    var id = UUID()
    var entry: MultiopNodeModel?
    var exit: MultiopNodeModel?
    
    enum CodingKeys: String, CodingKey {
        case entry
        case exit
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _entry = try? values.decode(MultiopNodeModel.self, forKey: .entry) {
            entry = _entry
        } else {
            entry = nil
        }
        
        if let _exit = try? values.decode(MultiopNodeModel.self, forKey: .exit) {
            exit = _exit
        } else {
            exit = nil
        }
    }
}

extension MultihopModel: Equatable {
    static func == (lhs: MultihopModel, rhs: MultihopModel) -> Bool {
        lhs.id == rhs.id
    }
}
