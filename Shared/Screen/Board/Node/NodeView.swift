//
//  NodeView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import SwiftUI
import TunnelKitManager

struct NodeView: View {
    @Binding var scale: CGFloat
    
    @State var sizeNode = CGFloat(16)
    // 1
    @State var node: Node
    //2
    @EnvironmentObject var mesh: Mesh
    //3
    
    @Binding var statusConnect: VPNStatus
    
    var isSelected: Bool {
        return mesh.isNodeSelected(node)
    }
    
    var multi: CGFloat {
        return mesh.showCityNodes ? 1.4 : 1
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Group {
                if isSelected {
                    NodePopupView(node: node, scale: $scale)
                } else {
                    Spacer()
                }
            }
            .frame(height: node.isCity ? 65 : 25)
            ZStack {
                if statusConnect == .connected {
                    if isConnectedNode {
                        Asset.Assets.nodeChange.swiftUIImage
                            .resizable()
                            .frame(width: sizeNode * multi * 1.5,
                                   height: sizeNode * multi * 1.5)
                    } else {
                        Asset.Assets.nodeNotConnected.swiftUIImage
                            .resizable()
                            .frame(width: sizeNode * multi,
                                   height: sizeNode * multi)
                    }
                } else {
                    Asset.Assets.node.swiftUIImage
                        .resizable()
                        .frame(width: sizeNode * multi,
                               height: sizeNode * multi)
                }
            }
        }
        .scaleEffect(1 / scale, anchor: .bottom)
        .zIndex(zIndex)
    }
    
    var zIndex: Double {
        if isConnectedNode {
            return 1
        }
        return mesh.isNodeSelected(node) ? 1 : 0
    }
    
    var isConnectedNode: Bool {
        switch statusConnect == .connected ? AppSetting.shared.getBoardTabWhenConnecting() : AppSetting.shared.getCurrentTab() {
        case .location:
            if let nodeConnected = NetworkManager.shared.nodeConnecting,
               let nodeInMap = mesh.getCountryNode(nodeConnected) {
                return mesh.showConnectedNode(node, nodeSelected: nodeInMap)
            }
        case .staticIP:
            if let staticServer = NetworkManager.shared.selectStaticServer,
               let nodeInMap = mesh.getNodeByStaticServer(staticServer) {
                return mesh.showConnectedNode(node, nodeSelected: nodeInMap)
            }
        case .multiHop:
            if let multi = NetworkManager.shared.selectMultihop,
               let entryCity = multi.entry?.city,
               let exitCity = multi.exit?.city {
                if let entryCityInMap = mesh.getNodeInMap(entryCity) {
                    if mesh.showConnectedNode(node, nodeSelected: entryCityInMap) {
                        return true
                    }
                }
                if let exitCityInMap = mesh.getNodeInMap(exitCity) {
                    if mesh.showConnectedNode(node, nodeSelected: exitCityInMap) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
