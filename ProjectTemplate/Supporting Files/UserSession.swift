//
//  UserSession.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/7/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import UIKit

class UserSession {
    static let shared = UserSession()
    
    private var profileKey = "profileKey"
    private var regidKey = "regidKey"
    
    private var userStandard = UserDefaults.standard
    
    /// Check user logged in
    var isUserLoggedIn: Bool {
        return profile != nil
    }
    
    /// Remove data information of logged out user
    func setLoggedOut() {
        userStandard.removeObject(forKey: profileKey)
    }
    
    /// Set and store new profile data
    ///
    /// - Parameter profile: new profile data
    func setProfile(_ profile: Profile) {
        let data = NSKeyedArchiver.archivedData(withRootObject: profile)
        userStandard.set(data, forKey: profileKey)
    }
    
    /// Getting stored profile data
    var profile: Profile? {
        guard let data = userStandard.data(forKey: profileKey) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Profile
    }
    
    /// Set and store new token registration id for push notification
    ///
    /// - Parameter string: token string
    func setRegid(string: String) {
        userStandard.set(string, forKey: regidKey)
    }
    
    /// Getting stored token registration id for push notification
    var regid: String {
        return userStandard.string(forKey: regidKey) ?? ""
    }
}
