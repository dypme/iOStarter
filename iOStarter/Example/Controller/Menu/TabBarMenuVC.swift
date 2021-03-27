//
//  TabBarMenuVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class TabBarMenuVC: UITabBarController {

    var viewModel = MenuVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
    }
    
    func setupMenu() {
        viewControllers = viewModel.allMenuController
    }

}
