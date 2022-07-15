//
//  NoLoginView.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct NoLoginView: View {
    @State private var showView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Description.login)
            
            Button(L10n.login) {
                showView.toggle()
            }
            .buttonStyle(BlueButton())
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showView) {
            LoginView()
        }
    }
}

struct NoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NoLoginView()
    }
}
