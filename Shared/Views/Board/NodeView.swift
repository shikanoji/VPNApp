//
//  NodeView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 30/12/2021.
//

import SwiftUI

struct NodeView: View {
    var width = CGFloat(5)
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
            NodePopupView(node: node)
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
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: Node.simple1, selection: SelectionHandler())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .preferredColorScheme(.dark)
    }
}
