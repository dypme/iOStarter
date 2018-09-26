//
//  ForgotPassViewModel.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation

class ForgotPassVM {
    init() {
        
    }
    
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity used when register difference in every user (ex: email, code)
    ///   - error: Action when request error
    ///   - success: Action when request success
    func forgotPass(userid: String, error: ((String) -> Void)?, success: ((String) -> Void)?) {
        if userid.isEmpty {
            error?(ErrorConstant.completeForm)
            return
        }
        if !userid.isValidEmail {
            error?(ErrorConstant.emailValidity)
            return
        }
        success?("Sukses")
        
        // Make request to server
//        ApiHelper.shared.example(value: <#T##String#>) { (json, isSuccess, message) in
//            is isSuccess {
//                success?("Sukses")
//            } else {
//                error?(message)
//            }
//        }
    }
}
