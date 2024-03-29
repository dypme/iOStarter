//
//  AppError.swift
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

class ErrorString {
    /// Silahkan lengkapi data yang dibutuhkan
    static let completeForm = L10n.Error.completeForm
    
    /// Silahkan gunakan email yang valid.
    static let emailValidity = L10n.Error.emailValidity
    
    /// Silahkan gunakan email yang valid.
    static let passwordValidity = L10n.Error.passwordValidity
    
    /// Silahkan masukkan %@
    ///
    /// - Parameter p1: Data that must input
    /// - Returns: Text message and input data
    static func inputData(to p1: String) -> String {
        L10n.Error.inputData(p1)
    }
    
    /// Silahkan pilih %@
    ///
    /// - Parameter p1: Data that must choose
    /// - Returns: Text message and choosen data
    static func chooseData(in p1: String) -> String {
        L10n.Error.chooseData(p1)
    }
}
