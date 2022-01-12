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
}

extension Mesh {
    func addNode(_ node: Node) {
        nodes.append(node)
    }
    
    static func sampleMesh() -> Mesh {
        let mesh = Mesh()
        
        mesh.addNode(Node.simple1)
        mesh.addNode(Node.simple2)
        mesh.addNode(Node.simple3)
        
        mesh.cityNodes = [Node.simple0]
        
        return mesh
    }
}
