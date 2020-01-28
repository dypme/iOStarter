//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//

import Foundation

class RegisterVM {
    init() {
        
    }
    
    /// Send request to server
    ///
    /// - Parameters:
    ///   - userid: User identity difference in every user (ex: email, code)
    ///   - password: Password for userid
    ///   - onFailed: Action when request error
    ///   - onSuccess: Action when request success
    func registerRequest(userid: String, password: String, onFailed: ((String) -> Void)?, onSuccess: ((String) -> Void)?) {
        if userid.isEmpty || password.isEmpty {
            onFailed?(ErrorConstant.completeForm)
            return
        }
        if password.count < 6 {
            onFailed?(ErrorConstant.passwordLength)
            return
        }
        
        onSuccess?("Sukses")
        
        // Make request to server
//        ApiHelper.shared.example(value: <#T##String#>) { (json, isSuccess, message) in
//            is isSuccess {
//                success?("Sukses")
//            } else {
//                onFailed?(message)
//            }
//        }
    }
}