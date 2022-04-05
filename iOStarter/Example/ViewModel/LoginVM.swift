//
//  LoginVM.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation

class LoginVM {
    func errorMessage(email: String, password: String) -> String? {
        if email.isEmpty || password.isEmpty {
            return ErrorConstant.completeForm
        }
        if !email.isValidEmail {
            return ErrorConstant.emailValidity
        }
        if !password.isValidPassword {
            return ErrorConstant.passwordValidity
        }
        return nil
    }
    
    func login(email: String, password: String, callback: ViewModelRequestCallback) {
        ApiHelper.shared.localRequest(fileName: "user.json", callback: { json, isSuccess, message in
            if isSuccess {
                let user = User(fromJson: json)
                UserSession.shared.setProfile(user)
            }
            callback?(isSuccess, message)
        })
    }
}
