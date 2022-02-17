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
    @State var totalScale: CGFloat = 1
    
    @ObservedObject var mesh: Mesh
    @ObservedObject var selection: SelectionHandler
    
    static let widthScreen = UIScreen.main.bounds.width
    static let heightScreen = UIScreen.main.bounds.height
    
    static let ratioMap: CGFloat = 2048 / 1588
    
    @State var widthMap: CGFloat = widthScreen
    @State var heightMap: CGFloat = widthScreen / ratioMap
    
    
    @Binding var showCityNodes: Bool
    
    @State private var location: CGPoint = CGPoint(x: widthScreen / 2, y: widthScreen)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
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
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("map")
                .resizable()
                .frame(width: widthMap * totalScale,
                       height: heightMap * totalScale)
                .aspectRatio(contentMode: .fit)
                .position(location)
            NodeMapView(selection: selection,
                        nodes: $mesh.nodes,
                        cityNodes: $mesh.cityNodes,
                        showCityNode: $showCityNodes,
                        scale: $totalScale)
                .frame(width: widthMap * totalScale,
                       height: heightMap * totalScale)
                .position(x: location.x + totalScale,
                          y: location.y + totalScale)
        }
        .onReceive(selection.$selectedNodeIDs) {
            if let id = $0.first {
                moveToNode(id)
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
                    totalScale = progressingScale * magScale
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
            showCityNodes = newValue > Constant.Board.Map.enableCityZoom
        }
        totalScale = progressingScale * magScale
    }
    
    private func validateZoom(_ newValue: CGFloat) -> Bool {
        return newValue < Constant.Board.Map.maxZoom && newValue >= Constant.Board.Map.minZoom
    }
    
    func checkCollision() {
        let rangeWidth = widthMap * totalScale * 0.5
        
        if location.x >= rangeWidth {
            self.location.x = rangeWidth
        } else if location.x <= rangeWidth {
            self.location.x = widthMap - rangeWidth
        }
        
        let rangeHeight = heightMap * totalScale * 0.5
        
        if (heightMap * totalScale) >= (heightMap * 2) {
           if location.y <= (MapView.heightScreen - rangeHeight) {
                location.y = MapView.heightScreen - rangeHeight
            } else if location.y >= rangeHeight {
                location.y = rangeHeight
            }
        } else {
            if location.y <= rangeHeight {
                self.location.y = rangeHeight
            } else if location.y >= (MapView.heightScreen - rangeHeight) {
                location.y = MapView.heightScreen - rangeHeight
            }
        }
    }
    
    func moveToNode(_ id: NodeID) {
        if let xNode = mesh.nodeWithID(id)?.x,
           let yNode = mesh.nodeWithID(id)?.y {
            let x = totalScale * (widthMap / 2 - xNode) + MapView.widthScreen / 2
            let y = totalScale * (heightMap / 2 - yNode) + MapView.widthScreen
            
            location = CGPoint(
                x: x,
                y: y)
            
            checkCollision()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    @State static var value = false
    
    static var previews: some View {
        let mesh = Mesh.sampleMesh()
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
