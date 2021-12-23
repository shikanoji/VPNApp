//
//  Introduction.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 07/12/2021.
//

import Foundation
import SwiftUI

struct IntroductionPage: Hashable {
    var id = UUID()
    var image: Image
    var title: String
    var body: String
    
    static func getList() -> [IntroductionPage] {
        
        let intro1 = IntroductionPage(image: Image("Introduction-1"), title: LocalizedStringKey.Introduction.intro1Title.localized, body: LocalizedStringKey.Introduction.intro1Body.localized)
        
        let intro2 = IntroductionPage(image: Image("Introduction-2"), title: LocalizedStringKey.Introduction.intro2Title.localized, body: LocalizedStringKey.Introduction.intro2Title.localized)
        
        let intro3 = IntroductionPage(image: Image("Introduction-3"), title: LocalizedStringKey.Introduction.intro3Title.localized, body: LocalizedStringKey.Introduction.intro3Body.localized)
        
        return [intro1, intro2, intro3]
    }
    
    static func == (lhs: IntroductionPage, rhs: IntroductionPage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct IntroductionView: View {
    @State var index = 0
    @State private var signIn = false
    
    // test board screen
    @State private var isPresented = false
    
    var body: some View {
        Background() {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)
                HStack {
                    Spacer().frame(width: 10)
                    Image("Logo-small")
                    Spacer()
                }
                PagingView(index: $index.animation(), maxIndex: IntroductionPage.getList().count - 1) {
                    ForEach(IntroductionPage.getList(), id: \.self) { intro in
                        VStack{
                            intro.image
                                .resizable()
                                .scaledToFit()
                            Spacer().frame(height: 10)
                            Text(intro.title).setTitle()
                            Spacer().frame(height: 10)
                            Text(intro.body).setDefault()
                        }
                        
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
        }.navigationBarHidden(true)
    }
}

struct IntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
