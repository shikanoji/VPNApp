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
    var name = ""
    var iso2 = ""
    var iso3 = ""
    var region = ""
    var subRegion = ""
    var latitude = ""
    var longitude = ""
    var x: CGFloat = .zero
    var y: CGFloat = .zero
    var flag: String = ""
    var isCity = false
    var cityNodeList = [Node]()
    var countryId: Int
    var countryName = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case iso2
        case iso3
        case region
        case subRegion
        case latitude
        case longitude
        case flag
        case cityNodeList = "city"
        case x
        case y
        case countryId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(NodeID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        iso2 = try values.decode(String.self, forKey: .iso2)
        iso3 = try values.decode(String.self, forKey: .iso3)
        region = try values.decode(String.self, forKey: .region)
        subRegion = try values.decode(String.self, forKey: .subRegion)
        latitude = try values.decode(String.self, forKey: .latitude)
        longitude = try values.decode(String.self, forKey: .longitude)
        flag = try values.decode(String.self, forKey: .flag)
        cityNodeList = try values.decode([Node].self, forKey: .cityNodeList)
        x = try values.decode(CGFloat.self, forKey: .x)
        y = try values.decode(CGFloat.self, forKey: .y)
        countryId = try values.decode(Int.self, forKey: .countryId)
        
        cityNodeList = cityNodeList.map { city -> Node in
            var updateCity = city
            updateCity.flag = flag
            updateCity.countryName = name
            return updateCity
        }
    }
    
    init(id: NodeID = NodeID(),
         name: String = "",
         iso2: String = "",
         iso3: String = "",
         region: String = "",
         subRegion: String = "",
         latitude: String = "",
         longitude: String = "",
         x: CGFloat = .zero,
         y: CGFloat = .zero,
         flag: String = "",
         isCity: Bool = false,
         cityNodeList: [Node] = [],
         countryName: String = "",
         countryId: Int = 0) {
        self.id = id
        self.name = name
        self.iso2 = iso2
        self.iso3 = iso3
        self.region = region
        self.subRegion = subRegion
        self.latitude = latitude
        self.longitude = longitude
        self.x = x
        self.y = y
        self.flag = flag
        self.isCity = isCity
        self.cityNodeList = cityNodeList
        self.countryName = countryName
        self.countryId = countryId
    }
}

extension Node {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Node: Equatable {
    
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
    static let cityNode = Node(name: "Tokyo", flag: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg", countryName: "Jpan")
    static let cityNodeList = [
        cityNode
    ]
    static let country = Node(name: "Sweden", flag: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg", cityNodeList: cityNodeList)

    static let poland = Node(name: "Poland", flag: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
    static let usa = Node(name: "United States")
    static let france = Node(name: "France")
    static let tokyo = Node(name: "Tokyo", flag: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg", countryName: "Jpan")

    static let cityNodeCanada = [
        Node(name: "Ontario", countryName: "Cananda"),
        Node(name: "Prince Edward Island", countryName: "Cananda"),
        Node(name: "Yukon", countryName: "Cananda")
    ]

    static let canada = Node(name: "Cananda", flag: "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg", cityNodeList: cityNodeCanada)
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
    var dataLocations: [NodeListResult] = []
    var dataStaticIP: [NodeListResult] = []
    var dataMultihop: [NodeListResult] = []
    
    enum CodingKeys: String, CodingKey {
        case state
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        state = BoardViewModel.StateTab(rawValue: try values.decode(Int.self, forKey: .state)) ?? .location
        dataLocations = try values.decode([NodeListResult].self, forKey: .data)
    }
    
    init(state: BoardViewModel.StateTab,
         dataLocations: [NodeListResult] = [],
         dataStaticIP: [NodeListResult] = [],
         dataMultihop: [NodeListResult] = []) {
        self.state = state
        self.dataLocations = dataLocations
        self.dataStaticIP = dataStaticIP
        self.dataMultihop = dataMultihop
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
        NodeTab(state: .location, dataLocations: NodeListResult.example)
    ]
    
    static let location = NodeTab(state: .location, dataLocations: NodeListResult.example)
    static let multihop = NodeTab(state: .location)
}
