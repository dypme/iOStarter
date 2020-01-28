//
//  Extension.swift
//  SCG Jayamix
//
//  Created by Crocodic MBP-2 on 5/30/17.
//  Copyright © 2017 Crocodic Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    /// Status bar background view
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

