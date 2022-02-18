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
    @Binding var scale: CGFloat
    
    var body: some View {
        ZStack {
            if !showCityNode {
                ForEach(nodes) { node in
                    NodeView(scale: $scale, node: node, selection: self.selection)
                        .position(x: node.convertXToMap() * scale, y: node.convertYToMap() * scale - (scale - 0.8) * 8 - 18)
                        .onTapGesture {
                            self.selection.selectNode(node)
                        }
                        .zIndex(selection.selectedNodeIDs.first == node.id ? 1 : 0)
                }
            } else {
                ForEach(cityNodes, id: \.id) { node in
                    NodeView(scale: $scale, node: node, selection: self.selection)
                        .position(x: node.x * scale, y: node.y * scale)
                        .onTapGesture {
                            self.selection.selectNode(node)
                        }
                        .zIndex(selection.selectedNodeIDs.first == node.id ? 1 : 0)
                }
            }
        }
    }
}

struct NodeMapView_Previews: PreviewProvider {
    @State static var value = false
    @State static var scale: CGFloat = 1.0
    @State static var nodes = Node.cityNodeList
    
    static var previews: some View {
        let selection = SelectionHandler()
        return NodeMapView(selection: selection, nodes: $nodes, cityNodes: $nodes, showCityNode: $value, scale: $scale)
    }
}


