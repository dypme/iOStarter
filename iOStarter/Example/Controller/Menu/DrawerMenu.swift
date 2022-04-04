//
//  DrawerMenu.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit
import KYDrawerController

/// Setup drawer menu controller, here drawer controller variable used for application
class DrawerMenu {
    static let shared = DrawerMenu()
    
    // MARK: - Property
    /// Drawer controller used for application
    var drawerController: KYDrawerController?
    
    // MARK: - Action
    /// Initialize setup of drawer controller, setting center and left controller
    ///
    /// - Parameter centerViewController: Center viewcontroller that will show
    func setupDrawer(centerViewController: UIViewController) {
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 200)
        drawerController.mainViewController = centerViewController
        
        drawerController.drawerAnimationDuration = 0.2
        
        self.drawerController = drawerController
    }
    
    /// Change center view controller with new view controller
    ///
    /// - Parameter viewController: ViewController that change center
    func setCenter(_ viewController: UIViewController) {
        drawerController?.mainViewController = viewController
    }
    
    // MARK: -
    /// Open drawer function
    @objc func openDrawer() {
//        if let menuDrawer = drawerController?.leftViewController as? MenuDrawer {
//            menuDrawer.setupView()
//            menuDrawer.tableView.reloadData()
//        }
        drawerController?.setDrawerState(.opened, animated: true)
    }
    
    /// Close drawer function
    func closeDrawer() {
        drawerController?.setDrawerState(.closed, animated: true)
    }
    
}
