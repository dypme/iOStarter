//
//  Menu.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation

class TabBarMenu {
    enum TabBarMenuType {
        case home
        case table
        case collection
        case profile
    }
    
    let type: TabBarMenuType
    let name: String
    
    init(type: TabBarMenuType) {
        self.type = type
        switch type {
        case .home:
            self.name = L10n.Menu.home
        case .table:
            self.name = L10n.Menu.list("1")
        case .collection:
            self.name = L10n.Menu.list("2")
        case .profile:
            self.name = L10n.Menu.profile
        }
    }
}
