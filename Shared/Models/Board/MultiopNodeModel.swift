//
//  MutilhopModel.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 12/06/2022.
//

import Foundation

struct MultiopNodeModel: Codable {
    var serverId: Int?
    var node: Node?
    
    enum CodingKeys: String, CodingKey {
        case serverId
        case node = "country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _serverId = try? values.decode(Int.self, forKey: .serverId) {
            serverId = _serverId
        } else {
            serverId = nil
        }
        
        if let _node = try? values.decode(Node.self, forKey: .node) {
            node = _node
        } else {
            node = nil
        }
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
