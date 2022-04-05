//
//  TabBarMenuVM.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

class TabBarMenuVM {
    private(set) var menus = [TabBarMenu]()
    
    init() {
        let home = TabBarMenu(type: .home)
        let table = TabBarMenu(type: .table)
        let collection = TabBarMenu(type: .collection)
        let profile = TabBarMenu(type: .profile)
        menus = [home, table, collection, profile]
    }
    
    var menuControllers: [UIViewController] {
        var controllers = [UIViewController]()
        menus.forEach { menu in
            switch menu.type {
            case .home:
                controllers.append(StoryboardScene.Menu.homeNavigation.instantiate())
            case .table:
                controllers.append(StoryboardScene.Menu.tableNavigation.instantiate())
            case .collection:
                controllers.append(StoryboardScene.Menu.gridNavigation.instantiate())
            case .profile:
                if UserSession.shared.isUserLoggedIn {
                    controllers.append(StoryboardScene.Profile.profileNavigation.instantiate())
                } else {
                    controllers.append(StoryboardScene.Profile.notLoginNavigation.instantiate())
                }
            }
        }
        return controllers
    }
    
    
}
