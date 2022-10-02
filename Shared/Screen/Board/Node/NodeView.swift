//
//  NodeView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import SwiftUI
import TunnelKitManager

struct NumberMultiView: View {
    var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(text)
                .font(.system(size: 12))
                .frame(width: 20, height: 20, alignment: .center)
                .overlay(
                    Circle()
                        .size(width: 20, height: 20)
                        .stroke(Color.white, lineWidth: 3)
                )
            
            Triangle(soft: false)
                .frame(width: Constant.Board.NodePopupView.widthTriangle - 3,
                       height: Constant.Board.NodePopupView.heightTriangle + 2)
                .foregroundColor(Constant.Board.NodePopupView.backgroudTriangle)
        }
    }
}

struct NodeView: View {
    @Binding var scale: CGFloat
    
    let sizeNode = Constant.Board.Node.sizeNode
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
        return mesh.showCityNodes ? Constant.Board.Node.multiCityNode : Constant.Board.Node.multiCountryNode
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
            .frame(height: node.isCity ? Constant.Board.Node.heightPopupCity : Constant.Board.Node.heightPopupCountry)
            ZStack {
                if statusConnect == .connected {
                    if isMultihopNode {
                        if isEntryNodeMulti {
                            VStack(spacing: 0) {
                                NumberMultiView(text: "1")
                                Asset.Assets.nodeEntry.swiftUIImage
                                    .resizable()
                                    .frame(width: sizeNode * Constant.Board.Node.multiConnected * 0.9,
                                           height: sizeNode * Constant.Board.Node.multiConnected * 0.9)
                            }
                        } else if isExitNodeMulti {
                            VStack(spacing: 0) {
                                NumberMultiView(text: "2")
                                Asset.Assets.nodeChange.swiftUIImage
                                    .resizable()
                                    .frame(width: sizeNode * Constant.Board.Node.multiConnected,
                                           height: sizeNode * Constant.Board.Node.multiConnected)
                            }
                        } else {
                            Asset.Assets.nodeNotConnected.swiftUIImage
                                .resizable()
                                .frame(width: sizeNode * multi,
                                       height: sizeNode * multi)
                        }
                    } else {
                        if isConnectedNode {
                            Asset.Assets.nodeChange.swiftUIImage
                                .resizable()
                                .frame(width: sizeNode * Constant.Board.Node.multiConnected,
                                       height: sizeNode * Constant.Board.Node.multiConnected)
                        } else {
                            Asset.Assets.nodeNotConnected.swiftUIImage
                                .resizable()
                                .frame(width: sizeNode * multi,
                                       height: sizeNode * multi)
                        }
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
        } else if (isEntryNodeMulti || isExitNodeMulti) {
            return 1
        }
        return mesh.isNodeSelected(node) ? 1 : 0
    }
    
    var currentTab: StateTab {
        return statusConnect == .connected ? AppSetting.shared.getBoardTabWhenConnecting() : AppSetting.shared.getCurrentTab()
    }
    
    var isMultihopNode: Bool {
        return currentTab == .multiHop
    }
    
    var isEntryNodeMulti: Bool {
        if let multi = NetworkManager.shared.selectMultihop,
           let entryCity = multi.entry?.city,
           let entryCityInMap = mesh.getNodeInMap(entryCity) {
            return mesh.showConnectedNode(node, nodeSelected: entryCityInMap)
        }
        return false
    }
    
    var isExitNodeMulti: Bool {
        if let multi = NetworkManager.shared.selectMultihop,
           let exitCity = multi.exit?.city,
           let exitCityInMap = mesh.getNodeInMap(exitCity) {
            return mesh.showConnectedNode(node, nodeSelected: exitCityInMap)
        }
        return false
    }
    
    var isConnectedNode: Bool {
        switch currentTab {
        case .location:
            if let nodeConnected = NetworkManager.shared.nodeConnecting,
               let nodeInMap = mesh.getNodeInMap(nodeConnected) {
                return mesh.showConnectedNode(node, nodeSelected: nodeInMap)
            }
        case .staticIP:
            if let staticServer = NetworkManager.shared.selectStaticServer,
               let nodeInMap = mesh.getNodeByStaticServer(staticServer) {
                return mesh.showConnectedNode(node, nodeSelected: nodeInMap)
            }
        default:
            break
        }
        return false
    }
}
