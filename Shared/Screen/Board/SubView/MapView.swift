//
//  MapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/12/2021.
//

import SwiftUI
import TunnelKitManager

struct MapView: View {
    @State var currentAmount = 0.0 {
        didSet {
            mesh.showCityNodes = (currentAmount + finalAmount) > Constant.Board.Map.enableCityZoom
        }
    }
    @State var finalAmount = 1.0
    
    @ObservedObject var mesh: Mesh
    @ObservedObject var selection: SelectionHandler
    
    @State var widthMap: CGFloat = Constant.Board.Map.heightScreen * Constant.Board.Map.ration
    @State var heightMap: CGFloat = Constant.Board.Map.heightScreen
    
    @State private var location: CGPoint = CGPoint(
        x: Constant.Board.Map.widthScreen / 2,
        y: Constant.Board.Map.heightScreen / 2
    )
    
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    @Binding var statusConnect: VPNStatus
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
                checkCollision()
            }
            .updating($startLocation) { (value, startLocation, transition) in
                startLocation = startLocation ?? location
            }
            .onEnded { _ in
                checkCollision()
            }
    }
    
    func getNodeMapView() -> some View {
        let binding = Binding(
            get: { CGFloat(finalAmount + currentAmount) },
            set: { _ in }
        )
        
        switch mesh.currentTab {
        case .location, .multiHop:
            
            return AnyView(NodeMapView(selection: selection,
                                       mesh: mesh,
                                       scale: binding))
        case .staticIP:
            return AnyView(StaticNodeMapView(selection: selection,
                                             mesh: mesh,
                                             scale: binding))
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Asset.Assets.map.SuImage
                .resizable()
                .frame(width: widthMap * (finalAmount + currentAmount),
                       height: heightMap * (finalAmount + currentAmount))
                .aspectRatio(contentMode: .fit)
                .position(location)
            getNodeMapView()
                .frame(width: widthMap * (finalAmount + currentAmount),
                       height: heightMap * (finalAmount + currentAmount))
                .position(x: location.x,
                          y: location.y)
                .opacity(statusConnect == .connected ? 0 : 1)
        }
        .onReceive(selection.$selectedNodeIDs) {
            if let id = $0.first, let node = mesh.nodeWithID(id) {
                moveToNode(x: node.x, y: node.y)
                NetworkManager.shared.selectNode = node
            }
        }
        .onReceive(selection.$selectedStaticNodeIDs) {
            if let id = $0.first, let node = mesh.staticNodeWithID(id) {
                moveToNode(x: node.x, y: node.y)
                NetworkManager.shared.selectStaticServer = node
            }
        }
        .onReceive(mesh.$clientCountryNode) {
            if selection.selectedNodeIDs.count == 0
                && selection.selectedStaticNodeIDs.count == 0,
               let node = $0 {
                moveToNode(x: node.x, y: node.y)
            }
        }
        .animation(.easeIn)
        .edgesIgnoringSafeArea(.all)
        .gesture(
            simpleDrag
        )
        .gesture(
            MagnificationGesture()
                .onChanged { amount in
                    if validateZoom(amount - 1 + finalAmount) {
                        currentAmount = amount - 1
                        checkCollision()
                    }
                }
                .onEnded { amount in
                    if validateZoom(currentAmount + finalAmount) {
                        finalAmount += currentAmount
                        currentAmount = 0
                        checkCollision()
                    }
                }
        )
        .background(AppColor.background)
    }
    
    private func validateZoom(_ newValue: CGFloat) -> Bool {
        return newValue < Constant.Board.Map.maxZoom && newValue >= Constant.Board.Map.minZoom
    }
    
    func checkCollision() {
        let rangeHeight = heightMap * (finalAmount + currentAmount) * 0.5

        if location.y >= rangeHeight {
            self.location.y = rangeHeight
        }
        else if location.y <= (heightMap - rangeHeight) {
            location.y = heightMap - rangeHeight
        }
        
        let rangeWidth = widthMap * (finalAmount + currentAmount) * 0.5
         
        if location.x >= rangeWidth {
            location.x = rangeWidth
        } else if location.x <= Constant.Board.Map.widthScreen - rangeWidth {
            location.x = Constant.Board.Map.widthScreen - rangeWidth
        }
    }
    
    func moveToNode(x: CGFloat, y: CGFloat) {
        let xNode = Constant.convertXToMap(x)
        let yNode = Constant.convertYToMap(y)
        
        let x = (finalAmount + currentAmount) * (widthMap / 2 - xNode) + Constant.Board.Map.widthScreen / 2
        let y = (finalAmount + currentAmount) * (heightMap / 2 - yNode) + Constant.Board.Map.heightScreen / 2
        location = CGPoint(
            x: x,
            y: y
        )
        
        checkCollision()
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var value = false
    @State static var statusConnect: VPNStatus = .connected
    
    static var previews: some View {
        let mesh = Mesh.sampleMesh()
        return MapView(mesh: mesh, selection: SelectionHandler(),
                       statusConnect: $statusConnect)
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
