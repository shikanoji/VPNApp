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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
