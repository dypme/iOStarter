//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
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