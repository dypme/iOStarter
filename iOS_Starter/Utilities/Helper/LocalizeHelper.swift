//
//  LocalizableHelper.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 14/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import L10n_swift

class LocalizeHelper {
    
    // [START] Start of example using localize helper
    
    /// Hallo World
    ///
    /// Example definition localization key in default position
    static var halloWorld: String {
        return "halloWorld".l10n()
    }
    
    /// Attention
    ///
    /// Example definition localization with key in group position
    static var alertTitle: String {
        return "alert.title".l10n()
    }
    
    /// Please input %@
    ///
    /// Example definition localization with formatting in localization.
    ///
    /// Check this [link](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html) to know format specifiers
    ///
    /// - Parameter p1: argument string for insert in localization text
    /// - Returns: Localization text with a argument
    static func alertInputField(_ p1: String) -> String {
        return "alert.inputField".l10n(args: [p1])
    }
    
    /// Plural localization number of items
    ///
    /// 0: You don't gave any items
    ///
    /// 1: You have 1 item
    ///
    /// more than 1: You have %@ items
    ///
    /// Example definition localization when need to localize based on number of items
    ///
    /// - Parameter p1: Number of item
    /// - Returns: Localization text based on number of items
    static func pluralsNumberOfItems(_ p1: Int) -> String {
        return "plurals.numberOfItems".l10n(arg: p1)
    }
    
    // To make easier search variable or function text localize use triple slash (///) comment one of text language using in above variable or function, so when suggestion of class show you can look text of variable or function
    // [END] End of example using
    
    /// Select
    static var pickerFieldSelect: String {
        return "pickerField.select".l10n()
    }
    
    /// Cancel
    static var pickerFieldCancel: String {
        return "pickerField.cancel".l10n()
    }
}
