//
//  Introduction.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 07/12/2021.
//

import Foundation
import SwiftUI

struct IntroductionView: View {
    @State var index = 0
    @State private var signIn = false
    @State private var trial = false
    // test board screen
    @State private var isPresented = false
    
    var body: some View {
        Background() {
            VStack(spacing: 10) {
                Spacer().frame(height: 20)
                HStack {
                    Spacer().frame(width: 10)
                    Asset.Assets.logoSmall.swiftUIImage
                    Spacer()
                }
                Spacer()
                SlideIntroduction()
                AppButton(style: .themeButton, width: 300, height:50, text: L10n.Introduction.trialButton) {
                    self.signIn = true
                }
                NavigationLink(destination: LoginView(viewModel: LoginViewModel()), isActive: $signIn) { }
                AppButton(style: .darkButton, width: 300, height:50, text: "Sign In") {
                    self.signIn = true
                }
                Spacer()
                Text(L10n.Introduction.introBottomTitle)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
