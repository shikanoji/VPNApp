//
//  BoardView.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import SwiftUI

struct BoardView: View {
    
    @StateObject var viewModel: BoardViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var selection = SelectionHandler()
    
    @State var showAccount = false
    @State var showSettings = false
    @State var showBoardList = false
    
    private let transition = AnyTransition.asymmetric(insertion: .move(edge: .bottom),
                                                      removal: .move(edge: .bottom))
    
    private let transitionLeft = AnyTransition.asymmetric(insertion: .move(edge: .leading),
                                                      removal: .move(edge: .leading))
    
    private let transitionRight = AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                                      removal: .move(edge: .trailing))
    
    @State var showPopup = false
    
    @State private var dragged = CGSize.zero
    @State private var accumulated = CGSize.zero
    
    let heightScreen = Constant.Board.Map.heightScreen
    
    func constraintOffSet(_ value: CGFloat) -> CGFloat {
        var valueConstraint = value
        valueConstraint = valueConstraint <= 0 ? 0 : valueConstraint
        valueConstraint = valueConstraint >= heightScreen ? heightScreen : valueConstraint
        return valueConstraint
    }
    
    func caculatorDirection(_ value: CGFloat) -> CGFloat {
        var valueConstraint = value
        let caculatorHeightScreen = heightScreen * 0.4
        if valueConstraint < caculatorHeightScreen {
            valueConstraint = 0
        } else {
            withAnimation(.linear) {
                valueConstraint = heightScreen
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showBoardList = false
                dragged.height = .zero
                accumulated.height = .zero
            }
        }
        return valueConstraint
    }
    
    let drag = DragGesture(minimumDistance: 0.0)
    
    var body: some View {
        ZStack {
            contentMapView()
            if showAccount {
                accountView()
                    .transition(transitionRight)
            }
            if showSettings {
                settingView()
                    .transition(transitionLeft)
            }
            VStack {
                if showBoardList {
                    boardListView()
                        .transition(transition)
                        .offset(y: self.dragged.height)
                        .gesture(drag
                            .onChanged{ value in
                                let valueConstraint = value.translation.height + self.accumulated.height
                                self.dragged = CGSize(width: value.translation.width + self.accumulated.width,
                                                      height: constraintOffSet(valueConstraint))
                            }
                            .onEnded{ value in
                                let valueConstraint = value.translation.height + self.accumulated.height
                                self.dragged = CGSize(width: value.translation.width + self.accumulated.width,
                                                      height: caculatorDirection(valueConstraint))
                                self.accumulated = self.dragged
                            })
                }
            }
            
            if !viewModel.shouldHideAutoConnect {
                autoConnectView()
            }
            
            if !viewModel.shouldHideSession {
                sessionVPNView()
            }
            
            if viewModel.showAlert {
                toastView()
            }
            
            if viewModel.showAlertSessionSetting {
                VStack{
                    Spacer()
                    PopupSelectView(message: "Need terminal some sessions",
                                    confirmTitle: "Open Sessions",
                                    confirmAction: {
                        viewModel.showAlertSessionSetting = false
                        viewModel.shouldHideSession = false
                    })
                    .frame(alignment: .bottom)
                    .padding(.bottom, 20)
                }
            }
            
            
            if viewModel.showAlertAutoConnectSetting {
                VStack{
                    Spacer()
                    PopupSelectView(message: "Disable auto-conenct",
                                    confirmTitle: "SETTINGS",
                                    confirmAction: {
                        viewModel.showAlertAutoConnectSetting = false
                        viewModel.shouldHideAutoConnect = false
                    })
                    .frame(alignment: .bottom)
                    .padding(.bottom, 20)
                }
            }
        }
        .onChange(of: viewModel.showAlert, perform: { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    viewModel.showAlert = false
                }
            }
        })
        .onChange(of: viewModel.showAlertSessionSetting, perform: { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    viewModel.showAlertSessionSetting = false
                }
            }
        })
        .onChange(of: viewModel.showAlertAutoConnectSetting, perform: { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    viewModel.showAlertAutoConnectSetting = false
                }
            }
        })
        .onChange(of: viewModel.nodeConnected, perform: { newValue in
            if let node = newValue {
                selection.selectNode(node)
            }
            showAccount = false
            showSettings = false
            showBoardList = false
        })
        .onChange(of: viewModel.staticIPNodeSelecte, perform: { newValue in
            showAccount = false
            showSettings = false
            showBoardList = false
        })
        .onChange(of: viewModel.multihopSelect, perform: { newValue in
            showAccount = false
            showSettings = false
            showBoardList = false
        })
        .animation(Animation.linear(duration: 0.25))
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    func handlerTapLeftNavigation() {
        showSettings = true
    }
    
    func handlerTapRightNavigation() {
        showAccount = true
    }
    
    func accountView() -> some View {
        AccountView(showAccount: $showAccount,
                    statusConnect: $viewModel.stateUI, numberOfSession: AppSetting.shared.currentNumberDevice, viewModel: AccountViewModel())
    }
    
    func autoConnectView() -> some View {
        AutoConnectView(
            showSettings: .constant(true),
            showVPNSetting: .constant(true),
            shouldHideAutoConnect: $viewModel.shouldHideAutoConnect,
            statusConnect: $viewModel.stateUI,
            viewModel: AutoConnectViewModel())
    }
    
    func sessionVPNView() -> some View {
        SessionVPNView(
            showAccount: .constant(true),
            showTotalDevice: .constant(true),
            statusConnect: $viewModel.stateUI,
            viewModel: SessionVPNViewModel(),
            shouldHideSessionList: $viewModel.shouldHideSession)
    }
    
    func toastView() -> some View {
        VStack{
            Spacer()
            PopupSelectView(message: "An error occurred",
                            confirmTitle: "DISMISS",
                            confirmAction: {
                viewModel.showAlert = false
            })
            .frame(alignment: .bottom)
            .padding(.bottom, 20)
        }
    }
    
    func settingView() -> some View {
        SettingsView(showSettings: $showSettings,
                     statusConnect: $viewModel.stateUI,
                     showAutoConnect: $viewModel.showAutoConnect,
                     showProtocolConnect: $viewModel.showProtocolConnect,
                     showDNSSetting: $viewModel.showDNSSetting)
    }
    
    func boardListView() -> some View {
        BoardListView(showBoardList: $showBoardList,
                      currentTab: $viewModel.tab,
                      node: $viewModel.nodeConnected,
                      locationData: $viewModel.locationData,
                      staticIPData: $viewModel.staticIPData,
                      staticNode: $viewModel.staticIPNodeSelecte,
                      mutilhopList: $viewModel.mutilhopList,
                      multihopSelect: $viewModel.multihopSelect,
                      statusConnect: $viewModel.stateUI)
    }
    
    @State var zoomLogo = false
    
    func logoAnimation() -> some View {
        Group {
            Asset.Assets.logoConnectedBackground.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            Asset.Assets.logoConnected.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .scaleEffect(zoomLogo ? 0.9 : 1.1)
                .onAppear {
                    zoomLogo = !zoomLogo
                }
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
        }
    }
    
    func contentMapView() -> some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack {
                    MapView(mesh: viewModel.mesh,
                            selection: selection,
                            statusConnect: $viewModel.stateUI)
                    .allowsHitTesting(viewModel.stateUI != .connected)
                    if viewModel.stateUI == .connected {
                        logoAnimation()
                            .padding(.bottom, Constant.Board.QuickButton.widthSize)
                    }
                }
                VStack {
                    BoardNavigationView(status: viewModel.stateUI,
                                        tapLeftIcon: {
                        handlerTapLeftNavigation()
                    }, tapRightIcon: {
                        handlerTapRightNavigation()
                    })
                    StatusVPNView(ip: viewModel.ip, status: viewModel.stateUI, flag: viewModel.flag, name: viewModel.nameSelect)
                    Spacer()
                    ConnectButton(status: viewModel.stateUI,
                                  uploadSpeed: viewModel.uploadSpeed,
                                  downloadSpeed: viewModel.downloadSpeed)
                    .onTapGesture {
                        viewModel.connectOrDisconnectByUser = true
                        viewModel.ConnectOrDisconnectVPN()
                    }
                    Spacer()
                        .frame(height: Constant.Board.Tabs.topPadding)
                    BoardTabView(tab: $viewModel.tab, showBoardList: $showBoardList)
                        .padding(.bottom)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            if viewModel.showProgressView {
                // dont show loading
            }
        }
        .background(AppColor.background)
        .frame(alignment: .top)
        .animation(nil)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(viewModel: BoardViewModel())
    }
}
