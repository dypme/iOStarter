//
//  LocalizableHelper.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 14/08/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import L10n_swift

// [START] Start of example using plural localize helper
// Plural localizable index by self cannot generate by SwiftGen
// Normal localize use Localizable.strings for input data and generate by SwiftGen

extension L10n {
    internal enum Plurals {
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
        internal static func pluralsNumberOfItems(_ p1: Int) -> String {
            return L10n.tr("PluralLocalizable", "numberOfItems", p1)
        }
        
    }
}

extension L10n {
    // No need change this method
    private static func tr(_ table: String, _ key: String, _ args: Int) -> String {
        // swiftlint:disable:next nslocalizedstring_key
        let localize = NSLocalizedString(key, tableName: table, bundle: .main, value: "No data", comment: "No comment")
        return String(format: localize, args)
    }
}
