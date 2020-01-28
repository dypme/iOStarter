//
//  ExtInt.swift
//  BAPA Leader
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 Reprime. All rights reserved.
//

import Foundation

extension Int {
    /// Change integer data type into string format decimal
    var asDecimal: String {
        let formatter = NumberFormatter()
        formatter.locale = LocalizeHelper.shared.locale
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(integerLiteral: self))
        return string!
    }
    
    /// Change integer into boolean data type
    var toBool: Bool {
        return Bool(truncating: NSNumber(value: self))
    }
}

extension Int64 {
    /// Change integer64 data type into string format decimal
    var asDecimal: String {
        let formatter = NumberFormatter()
        formatter.locale = LocalizeHelper.shared.locale
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value: self))
        return string!
    }
}
