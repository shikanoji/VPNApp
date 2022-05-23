//
//  MapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/12/2021.
//

import SwiftUI

struct MapView: View {
    
    @State var progressingScale: CGFloat = 1
    @State var magScale: CGFloat = 1
    @State var totalScale: CGFloat = 2 {
        didSet {
            mesh.showCityNodes = totalScale > Constant.Board.Map.enableCityZoom
        }
    }
    
    @ObservedObject var mesh: Mesh
    @ObservedObject var selection: SelectionHandler
    
    @State var widthMap: CGFloat = Constant.Board.Map.widthScreen
    @State var heightMap: CGFloat = Constant.Board.Map.widthScreen / Constant.Board.Map.ration
    
    @State private var location: CGPoint = CGPoint(
        x: Constant.Board.Map.widthScreen / 2,
        y: Constant.Board.Map.widthScreen
    )
    
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    @Binding var statusConnect: BoardViewModel.StateBoard
    
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
        switch mesh.currentTab {
        case .location, .multiHop:
            return AnyView(NodeMapView(selection: selection,
                                       mesh: mesh,
                                       scale: $totalScale))
        case .staticIP:
            return AnyView(StaticNodeMapView(selection: selection,
                                             mesh: mesh,
                                             scale: $totalScale))
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Asset.Assets.map.SuImage
                .resizable()
                .frame(width: widthMap * totalScale,
                       height: heightMap * totalScale)
                .aspectRatio(contentMode: .fit)
                .position(location)
            getNodeMapView()
                .frame(width: widthMap * totalScale,
                       height: heightMap * totalScale)
                .position(x: location.x + totalScale,
                          y: location.y + totalScale)
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
                .onChanged {
                    if validateZoom(self.magScale * $0) {
                        progressingScale = $0
                    }
                    let updateScale = progressingScale * magScale
                    
                    if  updateScale < Constant.Board.Map.minZoom {
                        totalScale = Constant.Board.Map.minZoom
                    } else if updateScale > Constant.Board.Map.maxZoom {
                        totalScale = Constant.Board.Map.maxZoom
                    } else {
                        totalScale = updateScale
                    }
                }
                .onEnded {
                    onEndedZoom($0)
                })
        .background(AppColor.background)
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
            totalScale = progressingScale * magScale
        }
        checkCollision()
    }
    
    private func validateZoom(_ newValue: CGFloat) -> Bool {
        return newValue < Constant.Board.Map.maxZoom && newValue >= Constant.Board.Map.minZoom
    }
    
    func checkCollision() {
        let rangeWidth = widthMap * totalScale * 0.5
        
        if location.x >= rangeWidth {
            self.location.x = rangeWidth
        } else if location.x <= (widthMap - rangeWidth) {
            location.x = widthMap - rangeWidth
        }

        let rangeHeight = heightMap * totalScale * 0.5
        
        if rangeHeight * 2 > Constant.Board.Map.heightScreen {
            if location.y <= Constant.Board.Map.heightScreen - rangeHeight {
                location.y = Constant.Board.Map.heightScreen - rangeHeight
            } else if location.y >= rangeHeight {
                location.y = rangeHeight
            }
        } else if totalScale > 1 {
            if location.y <= rangeHeight {
                self.location.y = rangeHeight
            } else if location.y >= (Constant.Board.Map.heightScreen - rangeHeight){
                location.y = Constant.Board.Map.heightScreen - rangeHeight
            }
        } else {
            location.y = Constant.Board.Map.widthScreen
        }
    }
    
    func moveToNode(x: CGFloat, y: CGFloat) {
        let xNode = Constant.convertXToMap(x)
        let yNode = Constant.convertYToMap(y)
        let x = totalScale * (widthMap / 2 - xNode) + Constant.Board.Map.widthScreen / 2
        let y = totalScale * (heightMap / 2 - yNode) + Constant.Board.Map.widthScreen
        
        location = CGPoint(
            x: x,
            y: y)
        
        checkCollision()
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var value = false
    @State static var statusConnect: BoardViewModel.StateBoard = .connected
    
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
