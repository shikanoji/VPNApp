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

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
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
        initNotificationObs()
        return true
    }
    
    func initNotificationObs() {
        NotificationCenter.default.addObserver(self, selector: #selector(onReadyStart), name: Constant.NameNotification.appReadyStart, object: nil)
    }

    var timmerAppSetting: Timer?

    @objc func onReadyStart() {
        onStartApp()
    }

    func onStartApp() {
        timmerAppSetting?.invalidate()
        timmerAppSetting = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(onReloadAppSetting), userInfo: nil, repeats: true)
        onReloadAppSetting()
    }

    @objc func onReloadAppSetting() {
        AppSetting.shared.updaterServerIP()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
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
        print(userInfo)
        completionHandler(.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
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
}
