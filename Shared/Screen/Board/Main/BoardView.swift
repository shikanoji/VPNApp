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
    @EnvironmentObject var mesh: Mesh
    @EnvironmentObject var authentication: Authentication
    
    @State var showAccount = false
    @State var showSettings = false
    
    private let transitionLeft = AnyTransition.asymmetric(insertion: .move(edge: .leading),
                                                          removal: .move(edge: .leading))
    
    private let transitionRight = AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                                           removal: .move(edge: .trailing))
    
    @State var showPopup = false
    
    let drag = DragGesture(minimumDistance: 0.0)
    
    @State var showSessionView = false
    @State var showAutoConnectView = false
    
    var body: some View {
        ZStack {
            contentMapView()
            if showAccount {
                accountView()
                    .transition(transitionRight)
                    .zIndex(1)
            }
            if showSettings {
                settingView()
                    .transition(transitionLeft)
                    .zIndex(1)
            }
            
            if showAutoConnectView {
                autoConnectView()
            }
            
            if showSessionView {
                sessionVPNView()
            }
        }
        .popup(isPresented: $viewModel.showAlert,
               type: .floater(verticalPadding: 20),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 5,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: viewModel.error?.description ?? "An error occurred",
                            confirmTitle: "DISMISS",
                            confirmAction: {
                                viewModel.showAlert = false
                            })
                            .frame(alignment: .bottom)
                            .padding(.bottom, 20)
        }
        .popup(isPresented: $viewModel.showSessionTerminatedAlert,
               type: .floater(verticalPadding: 20),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 5,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: "Session terminated",
                            confirmTitle: "OK",
                            confirmAction: {
                                viewModel.showSessionTerminatedAlert = false
                            })
                            .frame(alignment: .bottom)
                            .padding(.bottom, 20)
        }
        .popup(isPresented: $viewModel.showAlertSessionSetting,
               type: .floater(verticalPadding: 20),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 5,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: "Need terminate other sessions",
                            confirmTitle: "Open Sessions",
                            confirmAction: {
                                viewModel.showAlertSessionSetting = false
                                showSessionView = true
                            })
                            .frame(alignment: .bottom)
                            .padding(.bottom, 20)
        }
        .popup(isPresented: $viewModel.showAlertAutoConnectSetting,
               type: .floater(verticalPadding: 20),
               position: .bottom,
               animation: .easeInOut,
               autohideIn: 5,
               closeOnTap: false,
               closeOnTapOutside: true) {
            PopupSelectView(message: "Disable auto-connect",
                            confirmTitle: "SETTINGS",
                            confirmAction: {
                                viewModel.showAlertAutoConnectSetting = false
                                showAutoConnectView = true
                            })
                            .frame(alignment: .bottom)
                            .padding(.bottom, 20)
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
        .animation(Animation.linear(duration: 0.25))
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onWillAppear {
            viewModel.mesh = mesh
            viewModel.authentication = authentication
            viewModel.configDataRemote()
            viewModel.configDataLocal()
        }
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
            showAutoConnectView: $showAutoConnectView,
            statusConnect: $viewModel.stateUI,
            viewModel: AutoConnectViewModel())
    }
    
    func sessionVPNView() -> some View {
        SessionVPNView(
            showAccount: .constant(true),
            showTotalDevice: $showSessionView,
            statusConnect: $viewModel.stateUI,
            viewModel: SessionVPNViewModel())
    }
    
    func settingView() -> some View {
        SettingsView(showSettings: $showSettings,
                     statusConnect: $viewModel.stateUI,
                     showAutoConnect: $viewModel.showAutoConnect,
                     showProtocolConnect: $viewModel.showProtocolConnect,
                     showDNSSetting: $viewModel.showDNSSetting)
    }
    
    func boardListView() -> some View {
        BoardListView(viewModel: viewModel,
                      nodeSelect: $viewModel.nodeSelectFromBoardList,
                      locationData: $viewModel.locationData,
                      staticIPData: $viewModel.staticIPData,
                      staticIPSelect: $viewModel.staticIPSelect,
                      mutilhopList: $viewModel.mutilhopList,
                      multihopSelect: $viewModel.multihopSelect,
                      statusConnect: $viewModel.stateUI,
                      flag: $viewModel.flag,
                      name: $viewModel.nameSelect)
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
                    MapView(statusConnect: $viewModel.stateUI)
                }
                VStack {
                    BoardNavigationView(status: viewModel.stateUI,
                                        tapLeftIcon: {
                                            handlerTapLeftNavigation()
                                        }, tapRightIcon: {
                                            handlerTapRightNavigation()
                                        })
                                        .zIndex(3)
                                        .padding(.top)
                    StatusVPNView(ip: viewModel.ip, status: viewModel.stateUI, flag: viewModel.flag, name: viewModel.nameSelect)
                        .padding(.top, 0)
                    Spacer()
                    ConnectButton(viewModel: viewModel,
                                  tapButton: {
                                      if viewModel.state != .connected {
                                          AppSetting.shared.saveBoardTabWhenConnecting(.location)
                                          if mesh.selectedNode == nil {
                                              NetworkManager.shared.nodeSelected = AppSetting.shared.getRecommendedCountries().first
                                          } else {
                                              if let node = mesh.selectedNode {
                                                  AppSetting.shared.saveBoardTabWhenConnecting(.location)
                                                  NetworkManager.shared.nodeSelected = node
                                              }
                                          }
                                      }
                                      NetworkManager.shared.needReconnect = false
                                      NetworkManager.shared.onlyDisconnectWithoutEndsession = true
                                      NetworkManager.shared.connectOrDisconnectByUser = true
                                      Task {
                                          await NetworkManager.shared.ConnectOrDisconnectVPN()
                                      }
                                  })
                    Spacer()
                        .frame(height: Constant.Board.Tabs.topPadding)
                    BoardTabView(viewModel: viewModel)
                        .padding(.bottom, 10)
                        .zIndex(1)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
        }
        .sheet(isPresented: $viewModel.showBoardListIphone) {
            boardListView()
                .onWillDisappear {
                    viewModel.showBoardListIphone = false
                }
        }
        .fullScreenCover(isPresented: $viewModel.showBoardListIpad) {
            boardListView()
                .onWillDisappear {
                    viewModel.showBoardListIpad = false
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

struct StateViewHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> StateViewHandler.Coordinator {
        Coordinator(onWillDisappear: onWillDisappear,
                    onWillAppear: onWillAppear)
    }

    let onWillDisappear: () -> Void
    let onWillAppear: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<StateViewHandler>) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<StateViewHandler>) {
    }

    typealias UIViewControllerType = UIViewController

    class Coordinator: UIViewController {
        let onWillDisappear: () -> Void
        let onWillAppear: () -> Void
        
        init(onWillDisappear: @escaping () -> Void,
             onWillAppear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}

struct StateViewModifier: ViewModifier {
    let onWillDisappear: () -> Void
    let onWillAppear: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(StateViewHandler(
                onWillDisappear: onWillDisappear,
                onWillAppear: onWillAppear))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        modifier(StateViewModifier(onWillDisappear: perform, onWillAppear: {}))
    }
    
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(StateViewModifier(onWillDisappear: {}, onWillAppear: perform))
    }
}
