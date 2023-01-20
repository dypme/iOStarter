//
//  WebContentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 05/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct WebContentUI: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            WebView(url: URL(string: "https://google.com")!, didStartLoad: {
                isLoading = true
            }) {
                isLoading = false
            }
            if isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Web Content")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebContentUI_Previews: PreviewProvider {
    static var previews: some View {
        WebContentUI()
    }
}
