//
//  LoginVM.swift
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
import SwiftyJSON
import SwiftNotificationCenter

class LoginVM {
    func errorMessage(email: String, password: String) -> String? {
        if email.isEmpty || password.isEmpty {
            return ErrorString.completeForm
        }
        if !email.isValidEmail {
            return ErrorString.emailValidity
        }
        if !password.isValidPassword {
            return ErrorString.passwordValidity
        }
        return nil
    }
    
    func login(email: String, password: String) {
        guard let url = Bundle.main.url(forResource: "user.json", withExtension: nil) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSON(data: data)
            let user = User(fromJson: json)
            UserSession.shared.profile = user
            Broadcaster.notify(UserSessionUpdate.self) {
                $0.updateUserLoggedIn()
            }
        } catch {
            print("Error parse JSON:", error.localizedDescription)
        }
    }
}
