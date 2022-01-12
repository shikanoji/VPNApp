//
//  NodeMapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 03/01/2022.
//

import Foundation
import SwiftUI

struct NodeMapView: View {
    @ObservedObject var selection: SelectionHandler
    @Binding var nodes: [Node]
    @Binding var cityNodes: [Node]
    @Binding var showCityNode: Bool
    
    var body: some View {
        ZStack {
            if !showCityNode {
                ForEach(nodes, id: \.id) { node in
                    NodeView(node: node, selection: self.selection)
                        .offset(x: node.position.x, y: node.position.y)
                        .onTapGesture {
                            self.selection.selectNode(node)
                        }
                }
            } else {
                ForEach(cityNodes, id: \.id) { node in
                    NodeView(node: node, selection: self.selection)
                        .offset(x: node.position.x, y: node.position.y)
                        .onTapGesture {
                            self.selection.selectNode(node)
                        }
                }
            }
        }
    }
}

struct NodeMapView_Previews: PreviewProvider {
    @State static var value = false
    
    static let node1 = Node(position: CGPoint(x: 60, y: 150), ensign: "hello")
    static let node2 = Node.simple1
    @State static var nodes = [node1, node2]
    
    static var previews: some View {
        let selection = SelectionHandler()
        return NodeMapView(selection: selection, nodes: $nodes, cityNodes: $nodes, showCityNode: $value)
    }
}


