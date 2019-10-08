//
//  DrawerMenu.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import UIKit

/// Setup drawer menu controller, here drawer controller variable used for application
class DrawerMenu {
    static let shared = DrawerMenu()
    
    // MARK: - Property
    /// Drawer controller used for application
    var drawerController: JVFloatingDrawerViewController?
    
    // MARK: - Action
    /// Initialize setup of drawer controller, setting center and left controller
    ///
    /// - Parameter centerViewController: Center viewcontroller that will show
    func setupDrawer(centerViewController: UIViewController) {
        let sideMenu = StoryboardScene.Main.drawerMenuVC.instantiate()
        
        let drawerController = JVFloatingDrawerViewController()
        drawerController.leftViewController = sideMenu
        drawerController.centerViewController = centerViewController
        
        let animator = JVFloatingDrawerSpringAnimator()
        animator.animationDuration = 0.7
        animator.initialSpringVelocity = 0
        animator.springDamping = 0.8
        drawerController.animator = animator
        
        self.drawerController = drawerController
    }
    
    /// Change center view controller with new view controller
    ///
    /// - Parameter viewController: ViewController that change center
    func setCenter(_ viewController: UIViewController) {
        drawerController?.centerViewController = viewController
    }
    
    // MARK: -
    /// Open drawer function
    @objc func openDrawer() {
//        if let menuDrawer = drawerController?.leftViewController as? MenuDrawer {
//            menuDrawer.setupView()
//            menuDrawer.tableView.reloadData()
//        }
        drawerController?.toggleDrawer(with: .left, animated: true, completion: { (finished) in
            
        })
    }
    
    /// Close drawer function
    func closeDrawer() {
        drawerController?.closeDrawer(with: .left, animated: true, completion: { (finished) in
            
        })
    }
    
}
