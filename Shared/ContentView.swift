//
//  ContentView.swift
//  Shared
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    init() {
        UITextField.appearance().tintColor = .white
        UIScrollView.appearance().bounces = false
    }
    var body: some View {
        ZStack{
            AppColor.background
            NavigationView {
                if authentication.isValidated {
                    BoardView(viewModel: BoardViewModel())
                } else {
                    IntroductionView()
                }
            }.navigationBarTitleDisplayMode(.inline)
                .navigationAppearance(backgroundColor: UIColor(AppColor.background), foregroundColor: UIColor.white, tintColor: UIColor.white, hideSeparator: true)
        }.ignoresSafeArea()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
