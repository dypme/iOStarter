//
//  ProfileVM.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import Foundation
import SwiftNotificationCenter

class ProfileVM: ObservableObject {
    @Published private var user: User
    
    init() {
        guard let user = UserSession.shared.profile else {
            fatalError("User not logged in")
        }
        self.user = user
    }
    
    var imageUrl: URL? {
        URL(string: user.image)
    }
    
    var firstName: String {
        user.firstName
    }
    
    var lastName: String {
        user.lastName
    }
    
    var email: String {
        user.email
    }
    
    var gender: String {
        user.gender
    }
    
    func setLogout() {
        UserSession.shared.profile = nil
        Broadcaster.notify(UserSessionUpdate.self) {
            $0.updateUserLoggedIn()
        }
    }
}
