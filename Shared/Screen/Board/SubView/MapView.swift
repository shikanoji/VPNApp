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
        x: 0,
        y: 0
//        x: Constant.Board.Map.widthScreen / 2,
//        y: Constant.Board.Map.heightScreen / 2
    ) {
        didSet {
            print("didSet \(location.x) \(location.y)")
        }
    }
    
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
    
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        ZoomableScrollView(content: {
            ZStack(alignment: .center) {
                Asset.Assets.map.SuImage
                    .resizable()
                    .background(AppColor.background)
//                    .aspectRatio(2048 / 1588, contentMode: .fill)
                getNodeMapView()
            }
        }, location: $location)
//        {
//            ZStack(alignment: .center) {
//                Asset.Assets.map.SuImage
//                    .resizable()
//                    .background(AppColor.background)
//                    .aspectRatio(2048 / 1588, contentMode: .fit)
//                    .frame(width: widthMap * (finalAmount + currentAmount),
//                           height: heightMap * (finalAmount + currentAmount))
//                    .position(location)
//                    .aspectRatio(contentMode: .fit)
//                getNodeMapView()
//                    .frame(width: widthMap * (finalAmount + currentAmount),
//                           height: heightMap * (finalAmount + currentAmount))
//                    .position(location)
//                    .opacity(statusConnect == .connected ? 0 : 1)
//            }
//            .aspectRatio(contentMode: .fill)
//            .background(AppColor.background)
//        }
        .onReceive(selection.$selectedNodeIDs) {
            if let id = $0.first, let node = mesh.nodeWithID(id) {
                moveToNode(x: node.x, y: node.y)
                NetworkManager.shared.selectNode = node
            }
        }
//        .onReceive(selection.$selectedStaticNodeIDs) {
//            if let id = $0.first, let node = mesh.staticNodeWithID(id) {
//                moveToNode(x: node.x, y: node.y)
//                NetworkManager.shared.selectStaticServer = node
//            }
//        }
//        .onReceive(mesh.$clientCountryNode) {
//            if selection.selectedNodeIDs.count == 0
//                && selection.selectedStaticNodeIDs.count == 0,
//               let node = $0 {
//                moveToNode(x: node.x, y: node.y)
//            }
//        }
        .animation(.easeIn)
        .edgesIgnoringSafeArea(.all)
//        .gesture(
//            simpleDrag
//        )
//        .gesture(
//            MagnificationGesture()
//                .onChanged { amount in
//                    if validateZoom(amount - 1 + finalAmount) {
//                        currentAmount = amount - 1
//                        checkCollision()
//                    }
//                }
//                .onEnded { amount in
//                    if validateZoom(currentAmount + finalAmount) {
//                        finalAmount += currentAmount
//                        currentAmount = 0
//                        checkCollision()
//                    }
//                }
//        )
//        .background(AppColor.background)
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
        
//        let x = (finalAmount + currentAmount) * (widthMap / 2 - xNode) + Constant.Board.Map.widthScreen / 2
//        let y = (finalAmount + currentAmount) * (heightMap / 2 - yNode) + Constant.Board.Map.heightScreen / 2
        
        location = CGPoint(
            x: x,
            y: y
        )
        
        print("moveToNode \(x) \(y)")
        
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

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content
    
    let scrollView = UIScrollView()
    
    @Binding var location: CGPoint
    
    init(@ViewBuilder content: () -> Content,
         location: Binding<CGPoint>) {
        self.content = content()
        self._location = location
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        // set up the UIScrollView
        print("makeUIView")
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        
        let hostedView = context.coordinator.hostingController.view!
//        hostedView.translatesAutoresizingMaskIntoConstraints = true
//        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        hostedView.frame = CGRect(x: 0, y: 0,
                                  width: Constant.Board.Map.heightScreen * Constant.Board.Map.ration,
                                  height: Constant.Board.Map.heightScreen)
        
        scrollView.addSubview(hostedView)
        
        let leftMargin: CGFloat = (scrollView.frame.size.width - hostedView.bounds.width)*0.5
        let topMargin: CGFloat = (scrollView.frame.size.height - hostedView.bounds.height)*0.5

        scrollView.contentOffset = CGPoint(x: max(0,-leftMargin), y: max(0,-topMargin));
        
        scrollView.contentSize = CGSize(
            width: max(hostedView.bounds.width, hostedView.bounds.width+1),
            height: max(hostedView.bounds.height, hostedView.bounds.height+1))
        
        print("hostedView.frame \(hostedView.frame)")
        print("scrollView.contentSize \(scrollView.contentSize)")
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content))
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        print("location \(location)")
        
        let x = (location.x / uiView.contentSize.width) * (uiView.contentSize.width - uiView.bounds.size.width)
        
        uiView.contentOffset = CGPoint(
            x: x,
            y: 0)
        
        context.coordinator.hostingController.rootView = self.content
        assert(context.coordinator.hostingController.view.superview == uiView)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>
        
        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            print("scale \(scale)")
            if(scale < scrollView.minimumZoomScale){
                scrollView.minimumZoomScale = scale
            }
            
            if(scale > scrollView.maximumZoomScale){
                scrollView.maximumZoomScale = scale
            }
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if(scrollView.zoomScale < 1){
                let leftMargin: CGFloat = (scrollView.frame.size.width - hostingController.view!.frame.width)*0.5
                let topMargin: CGFloat = (scrollView.frame.size.height - hostingController.view!.frame.height)*0.5
                scrollView.contentInset = UIEdgeInsets(top: max(0, topMargin), left: max(0,leftMargin), bottom: 0, right: 0)
            }
        }
    }
}
