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
                Text(L10n.Description.pleaseLoginFirst)
                    .font(.system(size: 16))
            }
            TextField("Email", text: $email)
            SecureField(L10n.password, text: $password)
            AppButton(action: {
                viewModel.login(email: email, password: password)
            }, text: L10n.login)
            Button(L10n.close) {
                presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity, maxHeight: 24)
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
