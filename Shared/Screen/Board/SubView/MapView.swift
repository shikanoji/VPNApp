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
            let showCityNodes = currentAmount > Constant.Board.Map.enableCityZoom
            
            self.isCityMap = showCityNodes
            if showCityNodes {
                if !mesh.showCityNodes {
                    enableShowCity = true
                    mesh.showCityNodes = true
                }
            } else {
                if mesh.showCityNodes {
                    enableShowCity = true
                    mesh.showCityNodes = false
                }
            }
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
    
    func getNodeMapView(_ isCityMap: Bool) -> some View {
        let binding = Binding(
            get: { currentAmount },
            set: { _ in }
        )
        
        switch mesh.currentTab {
        case .location, .multiHop:
            
            return AnyView(NodeMapView(selection: selection,
                                       mesh: mesh,
                                       scale: binding,
                                       isCityMap: isCityMap))
        case .staticIP:
            return AnyView(StaticNodeMapView(selection: selection,
                                             mesh: mesh,
                                             scale: binding))
        }
    }
    
    @State var isCityMap = false
    
    @State var enableShowCity = false {
        didSet {
            if enableShowCity {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.enableShowCity = false
                }
            }
        }
    }
    
    @State var enableUpdateMap = true {
        didSet {
            if enableUpdateMap {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.enableUpdateMap = false
                }
            }
        }
    }
    
    @State var contentSize: CGSize = Constant.Board.Map.contentOffSetScrolLView {
        didSet {
            Constant.Board.Map.contentOffSetScrolLView = contentSize
        }
    }
    
    var body: some View {
        ZoomableScrollView(content: {
            ZStack(alignment: .center) {
                Asset.Assets.map.SuImage
                    .resizable()
                    .background(AppColor.background)
                    .aspectRatio(2048 / 1588, contentMode: .fill)
                
                Group {
                    NodeMapView(selection: selection,
                                mesh: mesh,
                                scale: $currentAmount,
                                isCityMap: false)
                    .opacity(!isCityMap ? 1 : 0)

                    NodeMapView(selection: selection,
                                mesh: mesh,
                                scale: $currentAmount,
                                isCityMap: true)
                    .opacity(isCityMap ? 1 : 0)
                }
                .opacity(mesh.currentTab == .location ? 1 : 0)
                
                StaticNodeMapView(selection: selection,
                                  mesh: mesh,
                                  scale: $currentAmount)
                .opacity(mesh.currentTab == .staticIP ? 1 : 0)
            }
        }, location: $location, enableUpdateMap: enableUpdateMap, enableShowCity: enableShowCity, updateZoomScale: {
            enableUpdateMap = false
            self.currentAmount = $0
        }, contentSize: {
            self.contentSize = $0
        })
        .onAppear {
            self.enableUpdateMap = false
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
        enableUpdateMap = true
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
    
    var updateZoomScale: (Double) -> Void?
    var contentSize: (CGSize) -> Void?
    
    private var content: Content
    
    let scrollView = UIScrollView()
    
    @Binding var location: CGPoint
    
    var enableUpdateMap = true
    var enableShowCity = false
    
    init(@ViewBuilder content: () -> Content,
         location: Binding<CGPoint>,
         enableUpdateMap: Bool,
         enableShowCity: Bool,
         updateZoomScale: @escaping (Double)-> Void = { _ in },
         contentSize: @escaping (CGSize)-> Void = { _ in }
    ) {
        self.updateZoomScale = updateZoomScale
        self.content = content()
        self._location = location
        self.enableUpdateMap = enableUpdateMap
        self.enableShowCity = enableShowCity
        self.contentSize = contentSize
        
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 2)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
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
        
        if !enableShowCity {
            guard enableUpdateMap else {
                return
            }
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
        
        if !enableShowCity {
            uiView.setContentOffset(CGPoint(
                x: xOffSet,
                y: yOffSet), animated: true)
        }
        
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
            
            parent.contentSize(scrollView.contentSize)
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
