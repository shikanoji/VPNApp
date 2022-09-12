//
//  ContentView.swift
//  Shared
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    @EnvironmentObject var authentication: Authentication
    
    init() {
        UITextField.appearance().tintColor = .white
        UIScrollView.appearance().bounces = false
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
                    if authentication.showNoticeAlert {
                        NavigationView {
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
                                        LoginView(viewModel: LoginViewModel())
                                    } else {
                                        IntroductionView()
                                    }
                                }
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationAppearance(backgroundColor: UIColor(AppColor.background), foregroundColor: UIColor.white, tintColor: UIColor.white, hideSeparator: true)
                    } else {
                        NoticeView()
                    }
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
