//
//  TabBarMenuVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 14/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import SwiftNotificationCenter

class TabBarMenuVC: UITabBarController {
    
    let viewModel = TabBarMenuVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControllers()
        Broadcaster.register(UserSessionUpdate.self, observer: self)
    }
    
    func refreshControllers() {
        viewControllers = menuController()
    }
    
    func menuController() -> [UIViewController] {
        viewModel.menus.compactMap { menu in
            let vc: UIViewController
            switch menu.type {
            case .home:
                vc = HomeVC()
            case .table:
                vc = ListVC()
            case .collection:
                vc = GridVC()
            case .profile:
                if UserSession.shared.isUserLoggedIn {
                    vc = ProfileVC()
                } else {
                    vc = NoLoginVC()
                }
            case .components:
                vc = ComponentVC()
            }
            vc.navigationItem.title = menu.name
            vc.tabBarItem.image = UIImage(systemName: menu.systemImage)
            vc.tabBarItem.title = menu.name
            let nc = UINavigationController(rootViewController: vc)
            return nc
        }
    }

}

extension TabBarMenuVC: UserSessionUpdate {
    func updateUserLoggedIn() {
        refreshControllers()
    }
}
