//
//  StaticNodeView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 04/05/2022.
//

import Foundation
import SwiftUI

struct StaticNodeView: View {
    @Binding var scale: CGFloat
    
    var width = CGFloat(5)
    // 1
    @State var node: StaticServer
    //2
    @ObservedObject var selection: SelectionHandler
    //3
    var isSelected: Bool {
        return selection.isStaticNodeSelected(node)
    }
    
    @State var isCityNode = false
    
    var body: some View {
        VStack(spacing: 2) {
            StaticNodePopupView(node: node, scale: $scale)
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
