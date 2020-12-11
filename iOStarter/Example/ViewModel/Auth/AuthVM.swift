//
//  AuthVM.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 11/12/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import Foundation

class AuthVM {
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity difference in every user (ex: email, code)
    ///   - password: Password for userid
    ///   - onFailed: Action when request error
    ///   - onSuccess: Action when request success
    func loginRequest(userid: String, password: String, onFinish: ((Bool, String) -> Void)?) {
        if userid.isEmpty || password.isEmpty {
            onFinish?(false, ErrorConstant.completeForm)
            return
        }
        if !userid.isValidEmail {
            onFinish?(false, ErrorConstant.emailValidity)
            return
        }
        if password.count < 6 {
            onFinish?(false, ErrorConstant.passwordLength)
            return
        }
        
        let profile = Profile(id: 1, userid: userid, image: "blank_image", name: "Hallo World", email: "hallo@world.com", password: password)
        UserSession.shared.setProfile(profile)
        
        onFinish?(true, "Sukses")
        
        // Make request to server
        //        _ = ApiHelper.shared.example(value: <#T##String#>) { (json, isSuccess, message) in
        //            if isSuccess {
        //                onSuccess?("Sukses")
        //            } else {
        //                onFailed?(message)
        //            }
        //        }
    }
    
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity difference in every user (ex: email, code)
    ///   - password: Password for userid
    ///   - onFailed: Action when request error
    ///   - onSuccess: Action when request success
    func registerRequest(userid: String, password: String, onFinish: ((Bool, String) -> Void)?) {
        if userid.isEmpty || password.isEmpty {
            onFinish?(false, ErrorConstant.completeForm)
            return
        }
        if password.count < 6 {
            onFinish?(false, ErrorConstant.passwordLength)
            return
        }
        
        onFinish?(true, "Sukses")
    }
    
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity used when register difference in every user (ex: email, code)
    ///   - onFailed: Action when request error
    ///   - onSuccess: Action when request success
    func forgotPassRequest(userid: String, onFinish: ((Bool, String) -> Void)?) {
        if userid.isEmpty {
            onFinish?(false, ErrorConstant.completeForm)
            return
        }
        if !userid.isValidEmail {
            onFinish?(false, ErrorConstant.emailValidity)
            return
        }
        onFinish?(true, "Sukses")
    }
}
