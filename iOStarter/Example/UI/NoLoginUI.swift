//
//  NoLoginUI.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct NoLoginUI: View {
    @State private var showView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text(L10n.Description.login)
                
                Button(L10n.login) {
                    showView.toggle()
                }
                .buttonStyle(AppButtonStyle())
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $showView) {
                LoginUI()
            }
            .navigationBarTitle(L10n.Title.notLogin)
        }
    }
}

struct NoLoginUI_Previews: PreviewProvider {
    static var previews: some View {
        NoLoginUI()
    }
}
