//
//  UserSession.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/7/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit
import MMKV
import SwiftyJSON

class UserSession {
    static let shared = UserSession()
    
    private var profileKey = "profileKey"
    private var regidKey = "regidKey"
    
    private var userStandard = MMKV.default()
    
    func clearData() {
        userStandard?.clearAll()
    }
    
    /// Set and store new token registration id for push notification
    ///
    /// - Parameter string: token string
    func setRegid(string: String) {
        userStandard?.set(string, forKey: regidKey)
    }
    
    /// Getting stored token registration id for push notification
    var regid: String {
        return userStandard?.string(forKey: regidKey) ?? ""
    }
    
    // TODO: Example usage to save logged in user session
    /// Check user logged in
    var isUserLoggedIn: Bool {
        profile != nil
    }
    
    /// Remove data information of logged out user
    func setLoggedOut() {
        userStandard?.removeValue(forKey: profileKey)
    }
    
    /// Set and store new profile data
    ///
    /// - Parameter profile: new profile data
    func setProfile(_ profile: User) {
        guard let jsonStr = profile.toJson().rawString() else { fatalError("Converting JSON to raw string failed") }
        guard let chiperStr = jsonStr.encrypt else { fatalError("Failed to encrypt string") }
        userStandard?.set(chiperStr, forKey: profileKey)
    }

    /// Getting stored profile data
    var profile: User? {
        if let chiperStr = userStandard?.string(forKey: profileKey) {
            guard let plainStr = chiperStr.decrypt else { return nil }
            guard let jsonData = plainStr.data(using: .utf8), let json = try? JSON(data: jsonData) else { return nil }
            return plainStr.isEmpty ? nil : User(fromJson: json)
        }
        return nil
    }
}
