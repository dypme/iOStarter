//
//  Constant.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation

class ErrorConstant {
    /// Silahkan lengkapi data yang dibutuhkan
    static let completeForm = "Silahkan lengkapi data yang dibutuhkan."
    
    /// Silahkan gunakan email yang valid.
    static let emailValidity = "Silahkan gunakan email yang valid."
    
    /// Silahkan gunakan email yang valid.
    static let passwordLength = "Silahkan gunakan email yang valid."
    
    /// Silahkan masukkan %@
    ///
    /// - Parameter p1: Data that must input
    /// - Returns: Text message and input data
    static func inputData(to p1: String) -> String {
        return "Silahkan masukkan \(p1)."
    }
    
    /// Silahkan pilih %@
    ///
    /// - Parameter p1: Data that must choose
    /// - Returns: Text message and choosen data
    static func chooseData(in p1: String) -> String {
        return "Silahkan pilih \(p1)."
    }
}
