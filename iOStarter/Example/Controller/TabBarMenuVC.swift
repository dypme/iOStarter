//
//  TabBarMenuVC.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
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