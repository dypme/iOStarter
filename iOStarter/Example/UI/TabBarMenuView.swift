//
//  TabBarMenuView.swift
//  iOStarter
//
//  Created by Macintosh on 30/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct TabBarMenuView: View {
    @StateObject private var viewModel = TabBarMenuVM()
    @StateObject private var userSession = UserSession.shared
    
    var body: some View {
        TabView {
            ForEach(viewModel.menus, id: \.type) { menu in
                menuView(type: menu.type)
                    .tabItem {
                        Text(menu.name)
                    }
            }
        }
    }
    
    @ViewBuilder
    func menuView(type: TabBarMenu.TabBarMenuType) -> some View {
        switch type {
        case .home:
            HomeView()
        case .table:
            ListView()
        case .collection:
            GridView()
        case .profile:
            if userSession.isUserLoggedIn {
                ProfileView()
            } else {
                NoLoginView()
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarMenuView()
    }
}
