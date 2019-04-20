//
//  NotificationHelper.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 7/12/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import SwiftyJSON
import AVKit

class NotificationHelper {
    static var shared = NotificationHelper()
    
    // [START setup]
    /// Setup all need for notification first
    func setupNotif(delegate: AppDelegate, application: UIApplication) {
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = delegate
        // [END set_messaging_delegate]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = delegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in
                
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
    }
    
    /// Save registration id token
    ///
    /// - Parameter deviceToken: Reg id to send notification in this device
    func register(deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
            Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
            Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserSession.shared.setRegid(string: refreshedToken)
        }
        if let token = Messaging.messaging().fcmToken {
            print("Fir token \(token)")
            UserSession.shared.setRegid(string: token)
        }
    }
    
    /// Update registration id token
    ///
    /// - Parameter notification: Notification sender when token refresh
    @objc func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserSession.shared.setRegid(string: refreshedToken)
        }
        if let token = Messaging.messaging().fcmToken {
            print("Fir token \(token)")
            UserSession.shared.setRegid(string: token)
        }
    }
    
    /// When set to `YES`, Firebase Messaging will automatically establish a socket-based, direct channel to the FCM server. Enable this only if you are sending upstream messages or receiving non-APNS, data-only messages in foregrounded apps. Default is `NO`.
    ///
    /// - Parameter state: Pass data value
    func setEstablishedDirectChannel(_ state: Bool) {
        Messaging.messaging().shouldEstablishDirectChannel = state
    }
    // [END setup]
    
    /// Make action in application with received notification
    ///
    /// - Parameters:
    ///   - data: Received notification data
    ///   - state: Position of application
    func notification(data: [AnyHashable : Any]) {
        if !UserSession.shared.isUserLoggedIn {
            return
        }
        let json = JSON(data)
        print("Hey this is your notification \(json)")
        let title = json["title"].stringValue
        let content = json["content"].stringValue
        let action = json["action"].stringValue
        
        let state = UIApplication.shared.applicationState
        switch state {
        case .active:
            // Make a action when receive notification while application in use/ active
            AudioServicesPlayAlertSound(SystemSoundID(1007))
            if action == "action" {
                let notify = Notify(title: title, detail: content, image: nil)
                notify.appearance.textAlign = .left
                notify.setTapAction {
                    self.exampleAction()
                }
                notify.show()
            }
        case .inactive:
            // Make a action when application active but no interaction user in application
            self.exampleAction()
        case .background:
            // Make a action when application not use/ inactive/ not in application
            self.exampleAction()
        }
    }
    
    /// Example action of notification
    func exampleAction() {
        print("Oh, hey you got notification")
    }
    
}
