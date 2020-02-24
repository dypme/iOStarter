//
//  ExtDate.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation

extension Date {
    /// Formatting string from date
    ///
    /// - Parameter format: Format date want. Check this [link](http://nsdateformatter.com/) for all about formatting date in swift
    /// - Returns: String of date after formatting
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

