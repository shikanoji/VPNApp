//
//  File.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import Foundation
import CoreGraphics


class SelectionHandler: ObservableObject {
    @Published private(set) var selectedNode: Node?
    
    func removeSelectNode() {
        selectedNode = nil
    }
    
    func selectNode(_ node: Node) {
        selectedNode = node
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        return selectedNode?.id == node.id
    }
}
