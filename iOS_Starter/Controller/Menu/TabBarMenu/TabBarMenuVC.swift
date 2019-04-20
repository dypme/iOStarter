//
//  TabBarMenuVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class TabBarMenuVC: UITabBarController {

    var viewModel = MenuVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMenu() {
        viewControllers = viewModel.allMenuController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
