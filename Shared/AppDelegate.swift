//
//  AppDelegate.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 02/12/2021.
//

import Foundation
import Firebase
import FirebaseAnalytics
import FirebaseMessaging
import GoogleSignIn
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    static private(set) var shared: AppDelegate! = nil
    static var orientationLock = UIInterfaceOrientationMask.portrait
    private var currentBackGroundTask: BGProcessingTask?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var filePath:String!
#if DEBUG
        filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")
#elseif RELEASE
        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
#endif
        guard let path = filePath, let fileopts = FirebaseOptions(contentsOfFile: path) else {
            assertionFailure("Couldn't load config file")
            return true
        }
        FirebaseApp.configure(options: fileopts)
        AppSetting.shared.refreshTokenError = false
        AppSetting.shared.isRefreshingToken = false
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        AppSettingIP.shared.resetIP()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "sysvpn.client.ios.scheduled_refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGProcessingTask)
        }
        AppDelegate.shared = self
        AppSetting.shared.openVPNTunnelCouldBeDropped = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(endBGTaskOnSuccessfullyRestoreVPN),
            name: Constant.NameNotification.restoreVPNSuccessfully,
            object: nil
        )
        Constant.resetDomain()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
    
    func application(
        _ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
             
//        if let userInfoDict = userInfo as? [String: Any] {
//            if let needReconnect = userInfoDict["needReconnect"] as? String {
//                if needReconnect == "true" {
//                    NetworkManager.shared.checkVPNKill()
//                }
//            }
//        }
            
        completionHandler(.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                AppSetting.shared.fcmToken = token
                print("FCM registration token: \(token)")
            }
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
        -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func scheduleAppRefresh() {
        print("SCHEDULING APP REFRESH")
        let request = BGProcessingTaskRequest(identifier: "sysvpn.client.ios.scheduled_refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func handleAppRefresh(task: BGProcessingTask) {
        Task {
            print("REFRESHING APP")
            scheduleAppRefresh()
            currentBackGroundTask = task
            await NetworkManager.shared.checkIfVPNDropped()
            currentBackGroundTask = task
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Constant.resetDomain()
    }

    @objc func endBGTaskOnSuccessfullyRestoreVPN() {
        if currentBackGroundTask != nil {
            currentBackGroundTask?.setTaskCompleted(success: true)
            currentBackGroundTask = nil
        }
    }
}
