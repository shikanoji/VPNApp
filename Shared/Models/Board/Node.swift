//
//  Node.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics

typealias NodeID = UUID

struct Node: Identifiable, Codable {
    var id: NodeID
    var position: CGPoint = .zero
    var name = ""
    var subName = ""
    var ensign: String
    var isCity = false
    var cityNodeList = [Node]()
    
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case name
        case subName
        case ensign
        case isCity
        case cityNodeList
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(NodeID.self, forKey: .id)
        position = try values.decode(CGPoint.self, forKey: .position)
        name = try values.decode(String.self, forKey: .name)
        subName = try values.decode(String.self, forKey: .subName)
        ensign = try values.decode(String.self, forKey: .ensign)
        isCity = (try values.decode(Int.self, forKey: .isCity) == 1)
        cityNodeList = try values.decode([Node].self, forKey: .cityNodeList)
    }
    
    init(id: NodeID = NodeID(), position: CGPoint = .zero, name: String = "", subName: String = "", ensign: String = "", isCity: Bool = false, cityNodeList: [Node] = []) {
        self.id = id
        self.position = position
        self.name = name
        self.subName = name
        self.ensign = ensign
        self.isCity = isCity
        self.cityNodeList = cityNodeList
    }
}

extension Node {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Node {
    func getNumberCity() -> String {
        let count = cityNodeList.count
        switch count {
        case 0:
            return LocalizedStringKey.BoardList.singleLocation.localized
        case 1:
            return "1 " + LocalizedStringKey.BoardList.city.localized + " " + LocalizedStringKey.BoardList.avaiable.localized
        default:
            return "\(count) " + LocalizedStringKey.BoardList.city.localized + " " + LocalizedStringKey.BoardList.avaiable.localized
        }
    }
}

extension Node {
    static let cityNodeList = [
        Node(name: "Tokyo", subName: "Jpan", ensign: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"),
        Node(position: CGPoint(x: 100, y: -50), name: "Poland",subName: "22", ensign: "33"),
        Node(position: CGPoint(x: 100, y: -50), name: "Kristinehamn",subName: "Sweden", ensign: "33"),
        Node(position: CGPoint(x: 50, y: 50), name: "helo2",subName: "223", ensign: "334")
    ]
    static let simple1 = Node(name: "Sweden", subName: "", ensign: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg", cityNodeList: cityNodeList)
    static let simple0 = Node(position: CGPoint(x: 10, y: 10),name: "Sweden", subName: "Kristinehamn", ensign: "Sweden", isCity: true)
    static let simple2 = Node(position: CGPoint(x: 100, y: -50), name: "helo",subName: "22", ensign: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg")
    static let simple3 = Node(position: CGPoint(x: 50, y: 50), name: "helo2",subName: "223", ensign: "334")
    
    static let poland = Node(name: "Poland", ensign: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
    static let usa = Node(name: "United States")
    static let france = Node(name: "France")
    
    static let cityNodeCanada = [
        Node(name: "Ontario", subName: "Cananda"),
        Node(name: "Prince Edward Island", subName: "Cananda"),
        Node(name: "Yukon", subName: "Cananda")
    ]
    
    static let canada = Node(name: "Cananda", ensign: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg", cityNodeList: cityNodeCanada)
    static let ire = Node(name: "Ireland")
    static let gree = Node(name: "Greece")
    
    static let recent = [
        poland
    ]
    
    static let recommend = [
        usa, france
    ]
    
    static let all = [
        poland, usa, france, canada, ire, gree
    ]
}

enum NodeListType: Int {
    case recent = 0
    case recoomend = 1
    case all = 2
    
    var title: String {
        switch self {
        case .recent:
            return LocalizedStringKey.BoardList.recentLocation.localized
        case .recoomend:
            return LocalizedStringKey.BoardList.recommend.localized
        case .all:
            return LocalizedStringKey.BoardList.all.localized
        }
    }
}

struct NodeListResult: Identifiable, Decodable {
    let id = UUID()
    var typeList: NodeListType
    var nodeList: [Node]
    
    enum CodingKeys: String, CodingKey {
        case id
        case typeList
        case nodeList
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nodeList = try values.decode([Node].self, forKey: .nodeList)
        typeList = NodeListType(rawValue: try values.decode(Int.self, forKey: .typeList)) ?? .all
    }
    
    init(nodeList: [Node], type: NodeListType) {
        self.nodeList = nodeList
        self.typeList = type
    }
}

extension NodeListResult {
    static func == (lhs: NodeListResult, rhs: NodeListResult) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NodeTab: Identifiable, Decodable {
    let id = UUID()
    var state: BoardViewModel.StateTab
    var data: [NodeListResult]
    
    enum CodingKeys: String, CodingKey {
        case state
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        state = BoardViewModel.StateTab(rawValue: try values.decode(Int.self, forKey: .state)) ?? .location
        data = try values.decode([NodeListResult].self, forKey: .data)
    }
    
    init(state: BoardViewModel.StateTab, data: [NodeListResult]) {
        self.state = state
        self.data = data
    }
}

extension NodeListResult {
    static let example = [
        NodeListResult(nodeList: Node.recent, type: .recent),
        NodeListResult(nodeList: Node.recommend, type: .recoomend),
        NodeListResult(nodeList: Node.all, type: .all)
    ]
}

extension NodeTab {
    static let example = [
        NodeTab(state: .location, data: NodeListResult.example)
    ]
}
