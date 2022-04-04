//
//  ExtString.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation

extension String {
    /// Check email validity
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// Check phone number validity
    var isValidPhone: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && res.phoneNumber == self
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isValidPassword: Bool {
        let minCharacters = self.count >= 8
        let containsNumber = self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        let containsAlphanumberic = self.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil
        return minCharacters && containsNumber && containsAlphanumberic
    }
    
    /// Change date format to new format date
    ///
    /// - Parameters:
    ///   - old: Current format
    ///   - new: Format that will change
    /// - Returns: New format date
    func dateChange(from old: String, to new: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = old
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = new
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    /// Convert string format date to Date data type
    ///
    /// - Parameter format: Current format string date
    /// - Returns: Date from string
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}
