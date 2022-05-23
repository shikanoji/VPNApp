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
    
    @ObservedObject var mesh: Mesh
    
    @Binding var scale: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(mesh.getNodeViewShow()) { node in
                NodeView(scale: $scale, node: node, selection: self.selection)
                    .position(x: Constant.convertXToMap(node.x) * scale, y: Constant.convertYToMap(node.y) * scale - (scale - 0.8) * 8 - 18)
                    .onTapGesture {
                        self.selection.selectNode(node)
                    }
                    .zIndex(selection.selectedNodeIDs.first == node.id ? 1 : 0)
            }
        }
    }
}

struct NodeMapView_Previews: PreviewProvider {
    @State static var value = false
    @State static var scale: CGFloat = 1.0
    @State static var nodes = Node.cityNodeList
    @State static var staticNodes = StaticServer.simple
    @State static var mesh = Mesh()
    
    static var previews: some View {
        let selection = SelectionHandler()
        return NodeMapView(selection: selection, mesh: mesh, scale: $scale)
    }
}


