//
//  ExtUINavigationController.swift
//  BAPA Leader
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 Reprime. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationControllerBackButtonDelegate {
    /// Handle function for default back button item in navigation controller
    ///
    /// - Returns: Pass true if want default back button enable, Pass false if want default back button disable
    func viewControllerShouldPopOnBackButton() -> Bool
}

extension UINavigationController {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        if self.viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        
        var shouldPop = true
        if let viewController = self.topViewController as? NavigationControllerBackButtonDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackButton()
        }
        if (shouldPop) {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        view.alpha = 1.0
                    })
                }
            }
            
        }
        
        return false
    }
}
