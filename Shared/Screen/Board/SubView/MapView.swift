//
//  MapView.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 28/12/2021.
//

import SwiftUI
import TunnelKitManager

struct MapView: View {
    @State var currentAmount: CGFloat = 1.0 {
        didSet {
            mesh.showCityNodes = currentAmount > Constant.Board.Map.enableCityZoom
        }
    }
    
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
    
    func getNodeMapView() -> some View {
        let binding = Binding(
            get: { currentAmount },
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
        }, location: $location) { _ in
//            scale = $0
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
    }
    
    func moveToNode(x: CGFloat, y: CGFloat) {
        location = CGPoint(
            x: x,
            y: y
        )
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
    
    class ViewModel: ObservableObject {
        var shouldUpdateView = true
    }
    
    @ObservedObject var viewModel: Self.ViewModel
    
    var updateZoomScale: (Double) -> Void
    
    private var content: Content
    
    let scrollView = UIScrollView()
    
    @Binding var location: CGPoint
    
    init(@ViewBuilder content: () -> Content,
         location: Binding<CGPoint>,
         updateZoomScale: @escaping (Double)-> Void = { _ in }) {
        self.updateZoomScale = updateZoomScale
        self.content = content()
        self._location = location
        self.viewModel = ViewModel()
        print("ZoomableScrollView init")
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        // set up the UIScrollView
        print("ZoomableScrollView makeUIView")
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        
        let hostedView = context.coordinator.hostingController.view!
        
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
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content), self)
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // update the hosting controller's SwiftUI content
        
        guard viewModel.shouldUpdateView else {
            viewModel.shouldUpdateView = true
            return
        }
        
        let widthScrollView = uiView.contentSize.width
        let maxWidthScrollView = widthScrollView - uiView.bounds.size.width
        let widthScreen = Constant.Board.Map.widthScreen
        
        let x = (location.x / (Constant.Board.Map.widthMapOrigin)) * (widthScrollView)
        
        var xOffSet = x - widthScreen / 2
        
        let heighScrollView = uiView.contentSize.height
        let maxHeighScrollView = heighScrollView - uiView.bounds.size.height
        let heighScreen = Constant.Board.Map.heightScreen
        
        let y = (location.y / (Constant.Board.Map.heightMapOrigin)) * (heighScrollView)
        
        var yOffSet = y - heighScreen / 2
        
        xOffSet = xOffSet < 0 ? 0 : xOffSet
        xOffSet = xOffSet > maxWidthScrollView ? maxWidthScrollView : xOffSet
        
        yOffSet = yOffSet < 20 ? 20 : yOffSet
        yOffSet = yOffSet > maxHeighScrollView ? maxHeighScrollView : yOffSet
        
        uiView.setContentOffset(CGPoint(
            x: xOffSet,
            y: yOffSet), animated: true)
        
        context.coordinator.hostingController.rootView = self.content
        assert(context.coordinator.hostingController.view.superview == uiView)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>
        var parent: ZoomableScrollView
        
        init(hostingController: UIHostingController<Content>, _ parent: ZoomableScrollView) {
            self.parent = parent
            self.hostingController = hostingController
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            if(scale < scrollView.minimumZoomScale) {
                scrollView.minimumZoomScale = scale
            }
            
            if(scale > scrollView.maximumZoomScale) {
                scrollView.maximumZoomScale = scale
            }
            
            parent.viewModel.shouldUpdateView = false
            parent.updateZoomScale(scrollView.zoomScale)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y < 20 {
                scrollView.contentOffset.y = 20
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
