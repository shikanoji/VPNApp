//
//  Node.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics

typealias NodeID = UUID

struct Node: Identifiable, Decodable {
    var id: NodeID = NodeID()
    var position: CGPoint = .zero
    var name = ""
    var subName = ""
    var ensign: String
    var isCity = false
}

extension Node {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Node {
    static let simple1 = Node(name: "Japan", subName: "Tokyo", ensign: "japan")
    static let simple0 = Node(position: CGPoint(x: 10, y: 10),name: "Sweden", subName: "Kristinehamn", ensign: "Sweden", isCity: true)
    static let simple2 = Node(position: CGPoint(x: 100, y: -50), name: "helo",subName: "22", ensign: "33")
    static let simple3 = Node(position: CGPoint(x: 50, y: 50), name: "helo2",subName: "223", ensign: "334")
}
