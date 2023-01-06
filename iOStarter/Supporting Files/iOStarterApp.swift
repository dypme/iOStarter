//
//  iOStarterApp.swift
//  iOStarter
//
//  Created by MBP2022_1 on 03/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//


import SwiftUI

@main
struct iOStarterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabBarMenuUI()
        }
    }
}
