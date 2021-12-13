//
//  ContentView.swift
//  Shared
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    init() {
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    var body: some View {
        NavigationView {
            IntroductionView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
