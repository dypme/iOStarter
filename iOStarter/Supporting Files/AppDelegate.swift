//
//  AppDelegate.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/12/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

import NVActivityIndicatorView
import IQKeyboardManagerSwift

import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// INitialize main controller, Change return value with your main menu controller
    private var mainFirstVC: UIViewController? {
        // Grid menu viewcontoller
        let gridMenu = StoryboardScene.Main.gridMenuVCNav.instantiate()
        
        // Drawer menu viewcontroller
        // Change center view controller with your center viewcontroller
        let centerVC = StoryboardScene.Main.viewControllerNav.instantiate()
        // Add drawer menu button programmatically, if you want to add drawer button manually delete this function
        centerVC.topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_drawer"), style: .plain, target: DrawerMenu.shared, action: #selector(DrawerMenu.shared.openDrawer))
        DrawerMenu.shared.setupDrawer(centerViewController: centerVC)
        let drawerMenu = DrawerMenu.shared.drawerController
        
        // Tabbar menu viewcontroller
        let tabBarMenu = StoryboardScene.Main.tabBarMenuVC.instantiate()
        
        return tabBarMenu
    }
    /// Main view controller
    var mainVC: UIViewController?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setApp()
        setupView()
        
        // uncomment setupNotification if need push notification
//        setupNotification(application: application)
        
        return true
    }
    
    /// Setting all application need
    func setApp() {
        SettingsHelper.setupSettings()
        
//        FirebaseApp.configure()
        
        KeyboardManager.shared.start()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulse
        
//        AlertController.appearance.backgroundColor = UIColor.yellow
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func refreshMainController() {
        mainVC = mainFirstVC
    }
    
    /// Configure root view controller when applicatio open
    func setupView() {
        window?.backgroundColor = UIColor.white
        
        refreshMainController()
        // Make root in login if application need login first
        if UserSession.shared.isUserLoggedIn {
            // Change root viewcontroller with your first main menu
            window?.rootViewController = mainVC
        } else {
            let vc = StoryboardScene.Auth.loginVC.instantiate()
            window?.rootViewController = vc
        }
    }
    
    /// Setup notification settings
    func setupNotification(application: UIApplication) {
        NotificationHelper.shared.setupNotif(delegate: self, application: application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationHelper.shared.register(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print full message.
        print(userInfo)
        
        // Here action if notification tap
        NotificationHelper.shared.notification(data: userInfo)
        
        completionHandler(.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present")
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Here action if notification tap
        NotificationHelper.shared.notification(data: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didreceive")
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Here action if notification tap
        NotificationHelper.shared.notification(data: userInfo)
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        NotificationHelper.shared.refreshFcmToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        NotificationHelper.shared.refreshFcmToken()
    }
}
// [END ios_10_data_message_handling]
