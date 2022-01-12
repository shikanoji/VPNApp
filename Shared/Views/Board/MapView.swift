//
//  MapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/12/2021.
//

import SwiftUI

struct MapView: View {
    
    @State var portalPosition: CGPoint = .zero
    @State var dragOffset: CGSize = .zero
    
    @State var progressingScale: CGFloat = 1
    @State var magScale: CGFloat = 1
    
    @ObservedObject var mesh: Mesh
    @ObservedObject var selection: SelectionHandler
    
    let widthScreen = UIScreen.main.bounds.width
    let heightScreen = UIScreen.main.bounds.height
    
    @State var heighContentMapView: CGFloat = UIScreen.main.bounds.width * 3 / 4
    @State var widthContentMapView: CGFloat = UIScreen.main.bounds.width
    
    @State var sizeOfMap: CGSize = .zero
    
    @Binding var showCityNodes: Bool
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    Image("map")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.width * 3 / 4)
                        .background(AppColor.background)
                    NodeMapView(selection: selection, nodes: $mesh.nodes, cityNodes: $mesh.cityNodes, showCityNode: $showCityNodes)
                }
                .frame(width: geometry.size.width)
                .onReceive(selection.$selectedNodeIDs) {
                    if let id = $0.first {
                        moveToNode(id)
                    }
                }
                .background(AppColor.background)
                .offset(
                    x: self.portalPosition.x + self.dragOffset.width,
                    y: self.portalPosition.y + self.dragOffset.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height/2)
                .animation(.easeIn)
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(self.magScale * progressingScale)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            onChangedDragOffset(value.translation)
                        }
                        .onEnded { value in
                            onEndedDragOffset(value.translation)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged {
                            if validateZoom(self.magScale * $0) {
                                progressingScale = $0
                            }
                        }
                        .onEnded {
                            onEndedZoom($0)
                        })
            }
            .background(AppColor.background)
        }
    }
    
    private func onChangedZoom(_ newValue: CGFloat) {
        let newValue = self.magScale * progressingScale
        
        if validateZoom(newValue) {
            progressingScale = newValue
        }
    }
    
    private func onEndedZoom(_ newValue: CGFloat) {
        let newValue = self.magScale * newValue
        if validateZoom(newValue) {
            progressingScale = newValue
            magScale = newValue
            progressingScale = 1
            showCityNodes = newValue > Constant.Board.Map.enableCityZoom
        }
    }
    
    private func validateZoom(_ newValue: CGFloat) -> Bool {
        return newValue < Constant.Board.Map.maxZoom && newValue >= Constant.Board.Map.minZoom
    }
    
    private func onChangedDragOffset(_ newValue: CGSize) {
        let newY = portalPosition.y + dragOffset.height
        let newX = portalPosition.x + dragOffset.width
        
        if validateOffSetY(newY) {
            dragOffset.height = newValue.height
        }
        
        if validateOffSetX(newX) {
            dragOffset.width = newValue.width
        }
    }
    
    private func validateOffSetX(_ newX: CGFloat) -> Bool {
        let widthCurrentMapView = self.magScale * progressingScale * widthContentMapView
        guard widthCurrentMapView > widthScreen else {
            return false
        }
        return widthScreen + abs(newX) + (widthCurrentMapView * 0.8 - widthScreen) / 2 < widthCurrentMapView
    }
    
    private func validateOffSetY(_ newY: CGFloat) -> Bool {
        let maxRange = heightScreen - Constant.Board.Navigation.heightNavigationBar - Constant.Board.Tabs.heightSize
        let heightCurrentMapView = self.magScale * progressingScale * heighContentMapView
        return maxRange + abs(newY) < heightCurrentMapView
    }
    
    private func onEndedDragOffset(_ newValue: CGSize) {
        dragOffset = .zero
        
        let newY = portalPosition.y + newValue.height
        let newX = portalPosition.x + newValue.width
        
        if validateOffSetY(newY) {
            portalPosition.y = newY
        }
        
        if validateOffSetX(newX) {
            portalPosition.x = newX
        }
    }
    
    func moveToNode(_ id: NodeID) {
        if let position = mesh.nodeWithID(id)?.position {
            portalPosition = CGPoint(
                x: -position.x,
                y: -position.y)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    @State static var value = false
    
    static var previews: some View {
        let mesh = Mesh()
        let child1 = Node(position: CGPoint(x: 50, y: 50),
                          ensign: "Việt Nam")
        let child2 = Node.simple1
        
        [child1, child2].forEach {
            mesh.addNode($0)
        }
        return MapView(mesh: mesh, selection: SelectionHandler(), showCityNodes: $value)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}
