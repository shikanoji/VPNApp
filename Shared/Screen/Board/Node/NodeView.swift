//
//  NodeView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import SwiftUI

struct NodeView: View {
    @Binding var scale: CGFloat
    
    var width = CGFloat(10)
    // 1
    @State var node: Node
    //2
    @ObservedObject var selection: SelectionHandler
    //3
    var isSelected: Bool {
        return selection.isNodeSelected(node)
    }
    
    @State var isCityNode = false
    
    var body: some View {
        VStack(spacing: 2) {
            NodePopupView(node: node, scale: $scale)
                .opacity(isSelected ? 1 : 0)
            ZStack {
                Ellipse()
                    .fill(AppColor.themeColor)
                    .frame(width: width * 2,
                           height: width * 2)
                    .opacity(0.2)
                Ellipse()
                    .fill(AppColor.themeColor)
                    .frame(width: width,
                           height: width)
            }
        }
        .scaleEffect(1 / scale, anchor: .bottom)
    }
}

struct NodeView_Previews: PreviewProvider {
    @State static var scale: CGFloat = 1.0
    
    static var previews: some View {
        NodeView(scale: $scale, node: Node.country, selection: SelectionHandler())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .preferredColorScheme(.dark)
    }
}
