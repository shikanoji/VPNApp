//
//  Mesh.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics

class Mesh: ObservableObject {
    @Published var countryNodes: [Node] = []
    @Published var cityNodes: [Node] = []
    @Published var staticNodes: [StaticServer] = []
    @Published var clientCountryNode: Node?
    
    @Published var showCityNodes: Bool = false
    @Published private(set) var selectedNode: Node?
    
    var currentTab: StateTab = .location
    
    init() {
        
    }
    
    func nodeWithID(_ nodeID: NodeID) -> Node? {
        let node = countryNodes.filter({ $0.id == nodeID }).first
        let cityNode = cityNodes.filter({ $0.id == nodeID }).first
        if (node != nil) {
            return node
        }
        if (cityNode != nil) {
            return cityNode
        }
        return nil
    }
    
    func staticNodeWithID(_ nodeID: Int) -> StaticServer? {
        let node = staticNodes.filter({ $0.id == nodeID }).first
        if (node != nil) {
            return node
        }
        return nil
    }
    
    func replace(_ node: Node, with replacement: Node) {
        var newSet = countryNodes.filter { $0.id != node.id }
        newSet.append(replacement)
        countryNodes = newSet
    }
    
    func configNode(countryNodes: [Node] = [],
                    cityNodes: [Node] = [],
                    staticNodes: [StaticServer] = [],
                    clientCountryNode: Node? = nil) {
        self.countryNodes = countryNodes
        self.cityNodes = cityNodes
        self.staticNodes = staticNodes
        self.clientCountryNode = clientCountryNode
    }
    
    func updateStaticNodes(_ staticNodes: [StaticServer] = []) {
        self.staticNodes = staticNodes
    }
    
    func updateCurrentTab(_ tab: StateTab) {
        currentTab = tab
    }
    
    func getNodeViewShow() -> [Node] {
        return showCityNodes ? cityNodes : countryNodes
    }
    
    func removeSelectNode() {
        selectedNode = nil
    }
    
    func selectNode(_ node: Node) {
        selectedNode = node
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        return selectedNode?.id == node.id
    }
    
    func getNodeToMove(_ node: Node) -> Node {
        if showCityNodes {
            return getCityNode(node)
        } else {
            return getCountryNode(node)
        }
    }
    
    func getCityNode(_ node: Node) -> Node {
        if !node.isCity {
            if let cityNode =  cityNodes.filter({
                node.id == $0.countryId
            }).first {
                return cityNode
            }
            return node
        } else {
            return node
        }
    }
    
    func getCountryNode(_ node: Node) -> Node {
        if node.isCity {
            if let countryNode =  countryNodes.filter({
                node.countryId == $0.id
            }).first {
                return countryNode
            }
            return node
        } else {
            return node
        }
    }
}

extension Mesh {
    func addNode(_ node: Node) {
        countryNodes.append(node)
    }
    
    static func sampleMesh() -> Mesh {
        let mesh = Mesh()
        
        for _ in 0...20 {
            mesh.addNode(Node(name: "Tokyo",
                              x: CGFloat.random(in: 0..<300),
                              y: CGFloat.random(in: 0..<400),
                              flag: "japan",
                              countryName: "Japan"))
        }
        mesh.addNode(Node(x: 100, y: 100))
        mesh.addNode(Node(x: 350, y: 200))
        mesh.cityNodes = [Node.country]
        
        return mesh
    }
}
