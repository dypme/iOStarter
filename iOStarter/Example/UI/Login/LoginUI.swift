//
//  LoginUI.swift
//  iOStarter
//
//  Created by Macintosh on 01/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import SwiftUI

struct LoginUI: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel = LoginVM()
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 5) {
                Text(L10n.login)
                    .font(.system(size: 20, weight: .bold))
                Text(L10n.Description.login)
                    .font(.system(size: 16))
            }
            TextField("Email", text: $email)
            SecureField(L10n.password, text: $password)
            Button(L10n.login) {
                viewModel.login(email: email, password: password)
            }
            .buttonStyle(AppButtonStyle())
            Button(L10n.close) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

struct LoginUI_Previews: PreviewProvider {
    static var previews: some View {
        LoginUI()
    }
}
