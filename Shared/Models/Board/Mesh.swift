//
//  Mesh.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics

class Mesh: ObservableObject {
    @Published var nodes: [Node] = []
    @Published var cityNodes: [Node] = []
    
    init() {
        
    }
    
    func nodeWithID(_ nodeID: NodeID) -> Node? {
        let node = nodes.filter({ $0.id == nodeID }).first
        let cityNode = cityNodes.filter({ $0.id == nodeID }).first
        if (node != nil) {
            return node
        }
        if (cityNode != nil) {
            return cityNode
        }
        return nil
    }
    
    func replace(_ node: Node, with replacement: Node) {
        var newSet = nodes.filter { $0.id != node.id }
        newSet.append(replacement)
        nodes = newSet
    }
    
    func configNode(nodes: [Node] = [], cityNodes: [Node] = []) {
        self.nodes = nodes
        self.cityNodes = cityNodes
    }
}

extension Mesh {
    func addNode(_ node: Node) {
        nodes.append(node)
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
