//
//  Node.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics

typealias NodeID = Int

struct Node: Identifiable, Codable {
    var id: NodeID
    var name = ""
    var iso2: String
    var iso3: String
    var region: String
    var subRegion: String
    var latitude: String
    var longitude: String
    var x: CGFloat
    var y: CGFloat
    var flag: String
    var isCity = false
    var cityNodeList = [Node]()
    var countryId: Int = 0
    var countryName: String = ""

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
        case countryName
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let _id = try? values.decode(NodeID.self, forKey: .id) {
            id = _id
        } else {
            id = 0
        }
        if let _name = try? values.decode(String.self, forKey: .name) {
            name = _name
        } else {
            name = ""
        }
        if let _iso2 = try? values.decode(String.self, forKey: .iso2) {
            iso2 = _iso2
        } else {
            iso2 = ""
        }
        if let _iso3 = try? values.decode(String.self, forKey: .iso3) {
            iso3 = _iso3
        } else {
            iso3 = ""
        }
        if let _region = try? values.decode(String.self, forKey: .region) {
            region = _region
        } else {
            region = ""
        }
        if let _subRegion = try? values.decode(String.self, forKey: .subRegion) {
            subRegion = _subRegion
        } else {
            subRegion = ""
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
        if let _cityNodeList = try? values.decode([Node].self, forKey: .cityNodeList) {
            cityNodeList = _cityNodeList
        } else {
            cityNodeList = []
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

        if let _countryId = try? values.decode(Int.self, forKey: .countryId) {
            countryId = _countryId
        } else {
            countryId = 0
        }

        if let _countryName = try? values.decode(String.self, forKey: .countryName) {
            countryName = _countryName
        }

        if !cityNodeList.isEmpty {
            cityNodeList = cityNodeList.map { city -> Node in
                var updateCity = city
                updateCity.flag = flag
                updateCity.countryName = name
                updateCity.countryId = id
                return updateCity
            }
        } 

        isCity = cityNodeList.count == 0

        if !isCity {
            countryName = name
        }
    }

    init(id: Int = 0,
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
            return L10n.Board.BoardList.singleLocation
        case 1:
            return "1 " + L10n.Board.BoardList.city + " " + L10n.Board.BoardList.available
        default:
            return "\(count) " + L10n.Board.BoardList.cities + " " + L10n.Board.BoardList.available
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

enum NodeGroupType: Int, Codable {
    case recent = 0
    case recommend = 1
    case all = 2

    var title: String {
        switch self {
        case .recent:
            return L10n.Board.BoardList.recentLocations
        case .recommend:
            return L10n.Board.BoardList.recommended
        case .all:
            return L10n.Board.BoardList.allCountries
        }
    }
}

struct NodeGroup: Codable {
    var type: NodeGroupType?
    var list: [Node]

    enum CodingKeys: String, CodingKey {
        case type
        case list
    }

    init(nodeList: [Node], type: NodeGroupType) {
        list = nodeList
        self.type = type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let _type = try? values.decode(NodeGroupType.self, forKey: .type) {
            type = _type
        } else {
            type = nil
        }

        if let _list = try? values.decode([Node].self, forKey: .list) {
            list = _list
        } else {
            list = []
        }
    }
}

struct NodeTabData: Identifiable {
    let id = UUID()
    var dataLocations: [NodeGroup] = []
    var dataStaticIP: [NodeGroup] = []
    var dataMultihop: [NodeGroup] = []

    init(dataLocations: [NodeGroup] = [],
         dataStaticIP: [NodeGroup] = [],
         dataMultihop: [NodeGroup] = []) {
        self.dataLocations = dataLocations
        self.dataStaticIP = dataStaticIP
        self.dataMultihop = dataMultihop
    }
}

extension NodeGroup {
    static let example = [
        NodeGroup(nodeList: Node.recent, type: .recent),
        NodeGroup(nodeList: Node.recommend, type: .recommend),
        NodeGroup(nodeList: Node.all, type: .all)
    ]
}

extension NodeTabData {
    static let example = [
        NodeTabData(dataLocations: NodeGroup.example)
    ]

    static let location = NodeTabData(dataLocations: NodeGroup.example)
    static let multihop = NodeTabData()
}
