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
    
    func removeSelectNode() {
        selectedNodeIDs = []
    }
    
    func selectNode(_ node: Node) {
        selectedNodeIDs = [node.id]
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        return selectedNodeIDs.contains(node.id)
    }
    
    @Published private(set) var selectedStaticNodeIDs: [Int] = []
    
    func selectStaticNode(_ node: StaticServer) {
        selectedStaticNodeIDs = [node.id]
    }
    
    func isStaticNodeSelected(_ node: StaticServer) -> Bool {
        return selectedStaticNodeIDs.contains(node.id)
    }
    
    func nodeIsSelected(_ node: Node) -> Bool {
        return selectedNodeIDs.contains(node.id)
    }
}
