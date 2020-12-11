//
//  MenuItemViewModel.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 25/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation

class MenuItemVM {
    private var menu = Menu()
    
    init() {
        
    }
    
    /// Initalize menu with specific
    ///
    /// - Parameter menu: Pass menu data
    init(menu: Menu) {
        self.menu = menu
    }
    
    /// Image of menu, why not use image request because icon in menu usually build in apps. If your menu icon get from server change this to function that can be copied from another View Model
    var image: UIImage? {
        return UIImage(named: menu.image)
    }
    
    /// Name of menu
    var name: String {
        return menu.name
    }
    
    /// Identity viewcontroller for every item
    var viewController: UIViewController? {
        switch menu.type {
        default:
            return nil
        }
    }
}
