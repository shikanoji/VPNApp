//
//  SlideIntroduction.swift
//  SysVPN
//
//  Created by Định Nguyễn on 07/09/2022.
//

import SwiftUI

struct IntroductionPage: Hashable {
    var id = UUID()
    var image: Image
    var title: String
    var body: String
    
    static func getList() -> [IntroductionPage] {
        
        let intro1 = IntroductionPage(image: Asset.Assets.introduction1.swiftUIImage, title: L10n.Introduction.intro1Title, body: L10n.Introduction.intro1Body)
        
        let intro2 = IntroductionPage(image: Asset.Assets.introduction2.swiftUIImage, title: L10n.Introduction.intro2Title, body: L10n.Introduction.intro2Title)
        
        let intro3 = IntroductionPage(image: Asset.Assets.introduction3.swiftUIImage, title: L10n.Introduction.intro3Title, body: L10n.Introduction.intro3Body)
        
        return [intro1, intro2, intro3]
    }
    
    static func == (lhs: IntroductionPage, rhs: IntroductionPage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SlideIntroduction: View {
    
    init(){
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.themeColor)
    }
    
    var body: some View {
        TabView {
            ForEach(IntroductionPage.getList(), id: \.self) { intro in
                VStack{
                    intro.image
                        .resizable()
                        .scaledToFit()
                    Spacer().frame(height: 10)
                    Text(intro.title).setTitle()
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 10)
                    Text(intro.body).setDefault()
                        .multilineTextAlignment(.center).padding(.bottom, 50)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .aspectRatio(3/4,contentMode: .fit)
        .frame(maxWidth:400)
        .font(Font.body.monospacedDigit())
    }
}

struct SlideIntroduction_Previews: PreviewProvider {
    static var previews: some View {
        SlideIntroduction()
    }
}

extension Color {
    static let themeColor = Color("darkThemeColor")
}
