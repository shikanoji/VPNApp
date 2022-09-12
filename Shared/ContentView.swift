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
    
    var body: some View {
        if viewModel.showSessionExpired {
            ForceLogoutView {
                viewModel.showSessionExpired = false
                AppSetting.shared.refreshTokenError = false
                authentication.logout()
                authentication.showedIntroduction = true
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
                                        } else {
                                            LoginView(viewModel: LoginViewModel())
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
