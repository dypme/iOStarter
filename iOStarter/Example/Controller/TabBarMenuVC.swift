//
//  TabBarMenuVC.swift
//  iOStarter
//
//  Created by Macintosh on 04/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class TabBarMenuVC: UITabBarController {

    let viewModel = TabBarMenuVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
    }
    
    func setupMenu() {
        viewControllers = viewModel.menuControllers
        
        viewModel.menus.enumerated().forEach { index, menu in
            tabBar.items?[index].title = menu.name
        }
    }

}

extension UIViewController {
    var tabBarMenuViewController: TabBarMenuVC? {
        self.tabBarController as? TabBarMenuVC
    }
}
