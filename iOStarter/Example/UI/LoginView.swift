//
//  LoginView.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(L10n.login)
                .font(.system(size: 20, weight: .bold))
            Text(L10n.Description.login)
                .font(.system(size: 16))
            Spacer()
                .frame(height: 24)
            TextField("Email", text: $email)
            SecureField(L10n.password, text: $password)
            Spacer()
                .frame(height: 24)
            Button("Login") {
                
            }
            .buttonStyle(BlueButton())
            
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
