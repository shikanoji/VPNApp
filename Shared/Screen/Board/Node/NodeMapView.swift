//
//  NodeMapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 03/01/2022.
//

import Foundation
import SwiftUI
import TunnelKitManager

struct NodeMapView: View {
    
    @EnvironmentObject var mesh: Mesh
    
    @Binding var scale: CGFloat
    
    @Binding var statusConnect: VPNStatus
    
    var body: some View {
        ZStack {
            ForEach(mesh.showCityNodes ? mesh.cityNodes : mesh.countryNodes) { node in
                NodeView(scale: $scale, node: node, mesh: mesh, statusConnect: $statusConnect)
                    .position(x: Constant.convertXToMap(node.x),
                              y: Constant.convertYToMap(node.y, mesh.showCityNodes))
                    .onTapGesture {
                        self.mesh.selectNode(node)
                    }
                    .zIndex(mesh.isNodeSelected(node) ? 1 : 0)
                    .animation(nil)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.mesh.removeSelectNode()
        }
    }
}
