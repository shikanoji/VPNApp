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
    
    @Binding var isZooming: Bool
    
    let colorsLeft = [
        AppColor.gradientEntry,
        AppColor.gradientEntry,
        AppColor.gradientExit,
        AppColor.gradientExit,
        AppColor.gradientExit
    ]
    
    let colorsRight = [
        AppColor.gradientExit,
        AppColor.gradientExit,
        AppColor.gradientEntry,
        AppColor.gradientEntry,
        AppColor.gradientEntry
    ]
    
    var body: some View {
        ZStack {
            ForEach(mesh.showCityNodes ? mesh.cityNodes : mesh.countryNodes) { node in
                if !(showMultihop && isZooming && !isMultihopNode(node)) {
                    NodeView(scale: $scale,
                             node: node,
                             statusConnect: $statusConnect)
                    .position(x: Constant.convertXToMap(node.x),
                              y: Constant.convertYToMap(node.y, mesh.showCityNodes, isMultihopNode(node) && showMultihop))
                    .onTapGesture {
                        self.mesh.selectNode(node)
                    }
                }
            }
            
            if showMultihop {
                if !isZooming {
                    multiView()
                        .stroke(
                            LinearGradient(colors: xEntrySmallerxExitNode ? colorsLeft : colorsRight,
                                           startPoint: .leading,
                                           endPoint:  .trailing),
                            lineWidth: 3 / scale
                        )
                        .onDisappear {
                            mesh.removeSelectNode()
                        }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.mesh.removeSelectNode()
        }
        .animation(nil)
    }
    
    func isMultihopNode(_ node: Node) -> Bool {
        return isEntryNodeMulti(node) || isExitNodeMulti(node)
    }
    
    var showMultihop: Bool {
        statusConnect == .connected && AppSetting.shared.getBoardTabWhenConnecting() == .multiHop
    }
    
    var paddingCenter: CGFloat {
        return mesh.showCityNodes ? Constant.Board.Node.paddingCenterCity : Constant.Board.Node.paddingCenterCountry
    }
    
    var xEntrySmallerxExitNode: Bool {
        if let multi = NetworkManager.shared.selectMultihop,
           let entry = multi.entry?.country,
           let exit = multi.exit?.country {
            return entry.x < exit.x
        }
        return false
    }
    
    func isEntryNodeMulti(_ node: Node) -> Bool {
        if let multi = NetworkManager.shared.selectMultihop,
           let entryCity = multi.entry?.city,
           let entryCityInMap = mesh.getNodeInMap(entryCity) {
            return mesh.showConnectedNode(node, nodeSelected: entryCityInMap)
        }
        return false
    }
    
    func isExitNodeMulti(_ node: Node) -> Bool {
        if let multi = NetworkManager.shared.selectMultihop,
           let exitCity = multi.exit?.city,
           let exitCityInMap = mesh.getNodeInMap(exitCity) {
            return mesh.showConnectedNode(node, nodeSelected: exitCityInMap)
        }
        return false
    }
    
    func multiView() -> Path {
        return Path { path in
            if let multi = NetworkManager.shared.selectMultihop,
               let entryCity = multi.entry?.city,
               let exitCity = multi.exit?.city {
                if let entryCityInMap = mesh.getNodeInMap(entryCity),
                   let exitCityInMap = mesh.getNodeInMap(exitCity) {
                    
                    let point1 = CGPoint(x: Constant.convertXToMap(entryCityInMap.x),
                                         y: Constant.convertYToMap(entryCityInMap.y, mesh.showCityNodes) + paddingCenter + paddingCenter * scale * 0.06)
                    
                    let point2 = CGPoint(x: Constant.convertXToMap(exitCityInMap.x),
                                         y: Constant.convertYToMap(exitCityInMap.y, mesh.showCityNodes)
                                         + paddingCenter + paddingCenter * scale * 0.06)
                    
                    let middlePoint = CGPoint(x: (point2.x + point1.x) / 2,
                                              y: min(point1.y, point2.y) - 50)
                    
                    path.move(to: point2)
                    path.addQuadCurve(to: point1,
                                      control: middlePoint)
                } else {
                    print("multiView error")
                }
            }
        }
    }
}
