//
//  SysVPNApp.swift
//  Shared
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import SwiftUI

@main
struct SysVPNApp: App {
    let persistenceController = PersistenceController.shared
    @State var authentication = Authentication()
    @State var mesh = Mesh()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authentication)
                .environmentObject(mesh)
                .environmentObject(NetworkTraffic.shared)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
