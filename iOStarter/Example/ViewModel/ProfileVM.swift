//
//  ProfileVM.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation

class ProfileVM {
    private let user: User
    
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
        UserSession.shared.setLoggedOut()
    }
}
