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

//import Firebase
import UserNotifications

import MMKV

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// INitialize main controller, Change return value with your main menu controller
    func initializeMainController() {
        mainController = StoryboardScene.Main.tabBarMenuVC.instantiate()
        mainController.modalPresentationStyle = .fullScreen
    }
    /// Main view controller
    var mainController: UIViewController!
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setApp()
        setupView()
        
        // uncomment setupNotification if need push notification
        setupNotification(application: application)
        
        return true
    }
    
    /// Setting all application need
    func setApp() {
        initializeMainController()
        
        MMKV.initialize(rootDir: nil)
        
        SettingsHelper.setupSettings()
        
        KeyboardStateListener.shared.start()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
//        FirebaseApp.configure()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulse
        
//        AlertController.appearance.backgroundColor = UIColor.yellow
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            fatalError("Test crashlytics")
//        }
    }
    
    /// Configure root view controller when applicatio open
    func setupView() {
        window?.backgroundColor = UIColor.white
        window?.rootViewController = StoryboardScene.Main.launchScreenVC.instantiate()
    }
    
    /// Setup notification settings
    func setupNotification(application: UIApplication) {
        NotificationHelper.shared.setupNotif(delegate: self, application: application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationHelper.shared.register(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
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
