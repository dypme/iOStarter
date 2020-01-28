//
//  ExtBool.swift
//  BAPA Leader
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 Reprime. All rights reserved.
//

import Foundation

extension Bool {
    /// Change boolean into integer data type
    var toInt: Int {
        return Int(truncating: NSNumber(value: self))
    }
}
