//
//  TabBarMenuUI.swift
//  iOStarter
//
//  Created by Macintosh on 30/06/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct TabBarMenuUI: View {
    @StateObject private var viewModel = TabBarMenuVM()
    @StateObject private var userSession = UserSession.shared
    @State private var selectedTab: TabBarMenu = TabBarMenu(type: .home)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(viewModel.menus, id: \.self) { menu in
                NavigationView {
                    menuView(type: menu.type)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(menu.name)
                }
                .tabItem {
                    Label(menu.name, systemImage: menu.systemImage)
                }
            }
        }
    }
    
    @ViewBuilder
    func menuView(type: TabBarMenu.TabBarMenuType) -> some View {
        switch type {
        case .home:
            HomeUI()
        case .table:
            ListUI()
        case .collection:
            GridUI()
        case .profile:
            if userSession.isUserLoggedIn {
                ProfileUI()
            } else {
                NoLoginUI()
            }
        case .components:
            ComponentUI()
        }
    }
}

struct TabBarMenuUI_Previews: PreviewProvider {
    static var previews: some View {
        TabBarMenuUI()
    }
}
