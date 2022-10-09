//
//  ContentView.swift
//  Shared
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    @EnvironmentObject var authentication: Authentication
    
    init() {
        UITextField.appearance().tintColor = .white
        UIScrollView.appearance().bounces = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private let transitionRight = AnyTransition.move(edge: .trailing)
    
    @State var enableAnimation = false
    
    var body: some View {
        if !viewModel.checkIfConnectedVPNHasNoInternet {
            ZStack{
                AppColor.background
                AnimationLogo()
            }
            .ignoresSafeArea()
        } else if !Connectivity.sharedInstance.isReachable {
            ForceLogoutView(titleStr: "No internet", messageStr: "Please check your network connection", confirmStr: "Confirm") {
                exit(0)
            }
            .frame(width: UIScreen.main.bounds.width)
            .ignoresSafeArea()
        } else if viewModel.showSessionExpired {
            ForceLogoutView {
                viewModel.showSessionExpired = false
                AppSetting.shared.refreshTokenError = false
                authentication.logout()
                authentication.showedIntroduction = true
                viewModel.getIpInfoSuccess = true
                enableAnimation = false
            }
            .frame(width: UIScreen.main.bounds.width)
            .ignoresSafeArea()
        } else {
            ZStack{
                AppColor.background
                if !viewModel.getIpInfoSuccess {
                    AnimationLogo()
                } else {
                    NavigationView {
                        ZStack {
                            AppColor.background
                            if authentication.showNoticeAlert {
                                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, AppSetting.shared.forceUpdateVersion.contains(appVersion) {
                                    ForceUpdateView()
                                } else {
                                    if authentication.isValidated {
                                        if authentication.isPremium {
                                            BoardView(viewModel: BoardViewModel())
                                        } else {
                                            SubscriptionIntroduction()
                                        }
                                    } else {
                                        if authentication.showedIntroduction {
                                            if authentication.needToShowRegisterScreenBeforeLogin {
                                                RegisterView(viewModel: RegisterViewModel())
                                                    .transition(transitionRight)
                                            } else {
                                                LoginView(viewModel: LoginViewModel())
                                                    .transition(transitionRight)
                                            }
                                        } else {
                                            IntroductionView()
                                        }
                                    }
                                }
                            } else {
                                NoticeView()
                            }
                        }
                        .ignoresSafeArea()
                        .animation(enableAnimation ? .default : nil)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.enableAnimation = true
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationAppearance(backgroundColor: UIColor(AppColor.background), foregroundColor: UIColor.white, tintColor: UIColor.white, hideSeparator: true)
                }
            }
            .ignoresSafeArea()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
