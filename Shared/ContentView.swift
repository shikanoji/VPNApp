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
        ZStack{
            AppColor.background
            if !viewModel.getIpInfoSuccess {
                if viewModel.showProgressView {
                    Asset.Assets.map.SuImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    //                    Asset.Assets.logoMedium.SuImage
                    LoadingView()
                }
            } else {
                NavigationView {
                    if AppSetting.shared.showedNotice {
                        if authentication.isValidated {
                            if authentication.isPremium {
                                BoardView(viewModel: BoardViewModel())
                            } else {
                                SubscriptionIntroduction()
                            }
                        } else {
                            IntroductionView()
                        }
                    } else {
                        NoticeView()
                    }
                    
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationAppearance(backgroundColor: UIColor(AppColor.background), foregroundColor: UIColor.white, tintColor: UIColor.white, hideSeparator: true)
            }
        }.ignoresSafeArea()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
