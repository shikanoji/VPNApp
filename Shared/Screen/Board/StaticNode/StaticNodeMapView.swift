//
//  StaticNodeMapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 04/05/2022.
//

import Foundation
import SwiftUI

struct StaticNodeMapView: View {
    @ObservedObject var selection: SelectionHandler
    
    @ObservedObject var mesh: Mesh
    
    @Binding var scale: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(mesh.staticNodes) { node in
                StaticNodeView(scale: $scale, node: node, selection: self.selection)
                    .position(x: Constant.convertXToMap(node.x),
                              y: Constant.convertYToMap(node.y, mesh.showCityNodes))
                    .onTapGesture {
                        self.selection.selectStaticNode(node)
                    }
                    .zIndex(selection.selectedNodeIDs.first == node.id ? 1 : 0)
            }
        }
    }
}
