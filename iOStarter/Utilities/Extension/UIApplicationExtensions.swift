//
//  UIApplicationExtensions.swift
//  iOStarter
//
//  Created by MBP2022_1 on 03/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    // For support multiple windows
    var activeWindow: UIWindow? {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
