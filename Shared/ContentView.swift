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
    init() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().backgroundColor = UIColor(AppColor.background)
        UITextField.appearance().tintColor = .white
    }
    var body: some View {
        ZStack{
            AppColor.background
            NavigationView {
                IntroductionView()
            }.navigationBarTitleDisplayMode(.inline)
        }.ignoresSafeArea()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
