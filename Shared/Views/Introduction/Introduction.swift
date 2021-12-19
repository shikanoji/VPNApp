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
    
    var images = ["Introduction-1", "Introduction-2"]
    
    var body: some View {
        GeometryReader { geometry in
            Background(width: geometry.size.width, height: geometry.size.height) {
                VStack(spacing: 20) {
                    Spacer().frame(height:50)
                    PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                        ForEach(self.images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .aspectRatio(3/4, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    //                Stepper("Index: \(index)", value: $index.animation(.easeInOut), in: 0...images.count-1)
                    //                    .font(Font.body.monospacedDigit())
                    
                    AppButton(style: .themeButton, width: 300, height:50, text: LocalizedStringKey.Introduction.trialButton.localized) {
                        print("Trial")
                    }
                    NavigationLink(destination: LoginView(viewModel: LoginViewModel()), isActive: $signIn) { }
                    AppButton(style: .darkButton, width: 300, height:50, text: "Sign In") {
                        self.signIn = true
                    }
                    Spacer()
                }
                .padding()
            }
            
        }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
