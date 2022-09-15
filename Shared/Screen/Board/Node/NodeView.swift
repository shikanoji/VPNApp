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
    @ObservedObject var selection: SelectionHandler
    //3
    
    @Binding var statusConnect: VPNStatus
    
    var isSelected: Bool {
        return selection.isNodeSelected(node)
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
                if statusConnect == .connected && AppSetting.shared.getCurrentTabConnected() == .location {
                    if NetworkManager.shared.nodeConnected?.id == node.id {
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
}

struct NodeView_Previews: PreviewProvider {
    @State static var scale: CGFloat = 1.0
    
    static var previews: some View {
        NodeView(scale: $scale, node: Node.country, selection: SelectionHandler(), statusConnect: .constant(.connected))
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .preferredColorScheme(.dark)
    }
}
