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
    @ObservedObject var mesh: Mesh
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
                    if showConnectedNode {
                        Asset.Assets.nodeChange.swiftUIImage
                            .resizable()
                            .frame(width: sizeNode * multi * 1.5,
                                   height: sizeNode * multi * 1.5)
                    } else {
                        Asset.Assets.node.swiftUIImage
                            .resizable()
                            .frame(width: sizeNode * multi * 0.9,
                                   height: sizeNode * multi * 0.9)
                            .opacity(0.2)
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
    }
    
    var showConnectedNode: Bool {
        var show = 0

        switch statusConnect == .connected ? AppSetting.shared.getCurrentTabConnected() : AppSetting.shared.getCurrentTab() {
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
