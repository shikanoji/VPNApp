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
    
    @State var width = CGFloat(10)
    // 1
    @State var node: Node
    //2
    @ObservedObject var mesh: Mesh
    //3
    
    @Binding var statusConnect: VPNStatus
    
    var isSelected: Bool {
        return mesh.isNodeSelected(node)
    }
    
    var multi: CGFloat {
        return node.isCity ? 1.5 : 1.2
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if isSelected {
                NodePopupView(node: node, scale: $scale, isSelected: .constant(true))
            } else {
                NodePopupView(node: node, scale: $scale, isSelected: .constant(false))
                    .opacity(0)
            }
            ZStack {
                if statusConnect == .connected {
                    if showConnectedNode {
                        Asset.Assets.nodeChange.swiftUIImage
                            .resizable()
                            .frame(width: 18 * multi * 1.2, height: 18 * multi * 1.2)
                    } else {
                        Asset.Assets.node.swiftUIImage
                            .resizable()
                            .frame(width: 18 * multi, height: 18 * multi)
                            .opacity(0.2)
                    }
                } else {
                    Asset.Assets.node.swiftUIImage
                        .resizable()
                        .frame(width: 18 * multi, height: 18 * multi)
                }
            }
        }
        .frame(height: 80)
        .scaleEffect(1 / scale, anchor: .bottom)
    }
    
    var showConnectedNode: Bool {
        var show = 0
        //If is auto-connecting, dont change node map when change tab
        if AppSetting.shared.getAutoConnectProtocol() != .off, statusConnect == .connected {
            if let nodeConnected = NetworkManager.shared.getNodeConnect() {
                show = nodeConnected.id == node.id ? 1 : 0
                node.cityNodeList.forEach {
                    if nodeConnected.id == $0.id {
                        show += 1
                    }
                }
            }
            return show > 0
        }

        switch AppSetting.shared.getCurrentTab() {
        case .location:
            if let nodeConnected = NetworkManager.shared.getNodeConnect() {
                show = nodeConnected.id == node.id ? 1 : 0
                node.cityNodeList.forEach {
                    if nodeConnected.id == $0.id {
                        show += 1
                    }
                }
            }
        case .staticIP:
            if let staticIP = NetworkManager.shared.selectStaticServer {
                show = staticIP.countryId == node.id ? 1 : 0
                node.cityNodeList.forEach {
                    if staticIP.countryId == $0.id {
                        show += 1
                    }
                }
            }
        case .multiHop:
            break
        }
        
        return show > 0
    }
}
