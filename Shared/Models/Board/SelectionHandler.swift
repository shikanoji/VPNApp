//
//  File.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics


class SelectionHandler: ObservableObject {
    @Published private(set) var selectedNodeIDs: [NodeID] = []
    
    func selectNode(_ node: Node) {
        selectedNodeIDs = [node.id]
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        return selectedNodeIDs.contains(node.id)
    }
    
    func selectedNodes(in mesh: Mesh) -> [Node] {
        return selectedNodeIDs.compactMap { mesh.nodeWithID($0) }
    }
    
    func onlySelectedNode(in mesh: Mesh) -> Node? {
        let selectedNodes = self.selectedNodes(in: mesh)
        if selectedNodes.count == 1 {
            return selectedNodes.first
        }
        return nil
    }
}
