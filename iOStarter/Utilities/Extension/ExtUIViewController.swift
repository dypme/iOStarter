//
//  ExtUIViewController.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Handle custom back button without manual code
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let backBtn = self.navigationItem.leftBarButtonItem {
            if backBtn.tag == 0 {
                backBtn.target = self
                backBtn.action = #selector(backNavBar(_:))
            }
        }
    }
    
    /// Function back to presenting viewcontroller
    ///
    /// - Parameter barButtonItem: Sender of button bar item
    @objc private func backNavBar(_ barButtonItem: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// Show default simple Alert
    ///
    /// - Parameters:
    ///   - title: Title of alert
    ///   - message: Message of alert
    ///   - handler: Action if alert dismissed
    func simpleAlert(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(ok)
        self.present(alert, animated: true) {
            
        }
    }
    
    func topMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}
