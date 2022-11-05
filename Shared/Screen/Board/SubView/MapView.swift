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
            let showCity = currentAmount > Constant.Board.Map.enableCityZoom
            if mesh.showCityNodes != showCity {
                mesh.showCityNodes = showCity
                
                showNodeMapView = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showNodeMapView = true
                }
            }
        }
    }
    
    @EnvironmentObject var mesh: Mesh
    
    @State var widthMap: CGFloat = Constant.Board.Map.heightScreen * Constant.Board.Map.ration
    @State var heightMap: CGFloat = Constant.Board.Map.heightScreen
    
    @State private var location: CGPoint = AppSetting.shared.getLocationMap()
    
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    @Binding var statusConnect: VPNStatus
    
    @State var enableUpdateMap = true {
        didSet {
            if enableUpdateMap {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.enableUpdateMap = false
                }
            }
        }
    }
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State var showNodeMapView = true
    
    var body: some View {
        ZoomableScrollView(content: {
            AppColor.background
            ZStack(alignment: .center) {
                Asset.Assets.map.swiftUIImage
                    .resizable()
                    .background(AppColor.background)
                    .aspectRatio(contentMode: .fill)

                if showNodeMapView {
                    NodeMapView(scale: $currentAmount,
                                statusConnect: $statusConnect)
                }
            }
            .padding(.bottom, -safeAreaInsets.bottom)
            .padding(.top, -safeAreaInsets.top)
        }, location: $location, enableUpdateMap: enableUpdateMap, updateZoomScale: { value in
            DispatchQueue.main.async {
                self.enableUpdateMap = false
                self.currentAmount = value
            }
        })
        .animation(.default)
        .onChange(of: statusConnect) { _ in
            moveToNodeConnected(statusConnect == .connected)
        }
        .onAppear {
            self.mesh.removeSelectNode()
            self.enableUpdateMap = false
            moveToNodeConnected(AppSetting.shared.isConnectedToVpn)
        }
        .onChange(of: mesh.selectedNode, perform: { newValue in
            if let node = newValue {
                moveToNode(x: node.x, y: node.y)
            }
        })
        .onChange(of: mesh.clientCountryNode, perform: { newValue in
            if !AppSetting.shared.isConnectedToVpn {
                if mesh.selectedNode == nil,
                   let node = newValue {
                    moveToNode(x: node.x, y: node.y)
                }
            }
        })
        .edgesIgnoringSafeArea(.all)
    }
    
    func moveToNodeConnected(_ connected: Bool = false) {
        if connected {
            mesh.removeSelectNode()
            switch AppSetting.shared.getBoardTabWhenConnecting() {
            case .location:
                if let node = NetworkManager.shared.nodeConnecting,
                   let moveNode = mesh.getNodeInMap(node) {
                    moveToNode(x: moveNode.x, y: moveNode.y)
                }
            case .staticIP:
                if let staticServer = NetworkManager.shared.selectStaticServer {
                    moveToNode(x: staticServer.x, y: staticServer.y)
                }
            case .multiHop:
                if let multihop = NetworkManager.shared.selectMultihop,
                   let country = multihop.exit?.country {
                    moveToNode(x: country.x, y: country.y)
                }
            }
        }
    }
    
    func moveToNode(x: CGFloat, y: CGFloat) {
        enableUpdateMap = true
        location = CGPoint(
            x: x,
            y: y
        )
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
    
    private var content: Content
    
    let scrollView = UIScrollView()
    
    @Binding var location: CGPoint
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var padding: CGFloat = 0
    
    var enableUpdateMap = true
    
    init(@ViewBuilder content: () -> Content,
         location: Binding<CGPoint>,
         enableUpdateMap: Bool,
         updateZoomScale: @escaping (Double)-> Void = { _ in }
    ) {
        self.updateZoomScale = updateZoomScale
        self.content = content()
        _location = location
        self.enableUpdateMap = enableUpdateMap
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 4)
        padding = safeAreaInsets.bottom
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.bounces = false
        
        let hostedView = context.coordinator.hostingController.view!
        
        hostedView.frame = CGRect(x: 0, y: 0,
                                  width: Constant.Board.Map.heightScreen * Constant.Board.Map.ration,
                                  height: Constant.Board.Map.heightScreen)
        
        scrollView.addSubview(hostedView)
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        if let hostedView = context.coordinator.hostingController.view {
            hostedView.frame = CGRect(x: 0, y: 0,
                                      width: Constant.Board.Map.heightScreen * Constant.Board.Map.ration,
                                      height: Constant.Board.Map.heightScreen)
            
            scrollView.addSubview(hostedView)
            
            scrollView.contentSize = CGSize(
                width: hostedView.bounds.width,
                height: hostedView.bounds.height)
        }
        
        scrollView.minimumZoomScale = Constant.Board.Map.minZoom
        scrollView.maximumZoomScale = Constant.Board.Map.maxZoom
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: content), self, padding: padding)
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
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
        
        yOffSet = yOffSet < padding * uiView.zoomScale ? padding * uiView.zoomScale : yOffSet
        yOffSet = yOffSet > maxHeighScrollView ? maxHeighScrollView : yOffSet
        
        if enableUpdateMap {
            uiView.setContentOffset(CGPoint(
                x: xOffSet,
                y: yOffSet), animated: true)
        }
        
        context.coordinator.hostingController.rootView = content
        assert(context.coordinator.hostingController.view.superview == uiView)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>
        var parent: ZoomableScrollView
        let padding: CGFloat
        
        init(hostingController: UIHostingController<Content>, _ parent: ZoomableScrollView, padding: CGFloat) {
            self.parent = parent
            self.hostingController = hostingController
            self.padding = padding
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y < (padding * scrollView.zoomScale) {
                scrollView.contentOffset.y = (padding * scrollView.zoomScale)
            }
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
//            scrollView.bouncesZoom = scrollView.zoomScale > 1
            if (scrollView.zoomScale < 1) {
                let frameHosting = hostingController.view.frame
                let leftMargin: CGFloat = (scrollView.frame.size.width - frameHosting.width)*0.5
                let topMargin: CGFloat = (scrollView.frame.size.height - frameHosting.height)*0.5
                scrollView.contentInset = UIEdgeInsets(top: max(0, topMargin), left: max(0,leftMargin), bottom: 0, right: 0)
            }
            parent.updateZoomScale(scrollView.zoomScale)
        }
    }
}
