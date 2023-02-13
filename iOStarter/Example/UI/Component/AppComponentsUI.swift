//
//  AppComponentsUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 26/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct AppComponentsUI: View {
    @State private var text = ""
    
    var body: some View {
        List {
            buildCustomButton()
            buildCustomField()
        }
    }
    
    @ViewBuilder
    func buildCustomButton() -> some View {
        Section {
            AppButton(action: {
                
            }, text: "Login")
            AppButton(action: {
                
            }, text: "Sign in with Apple", leadingIcon: Image(systemName: "apple.logo"), trailingIcon: Image(systemName: "chevron.right"))
        } header: {
            Text("App Button")
        }
    }
    
    @ViewBuilder
    func buildCustomField() -> some View {
        Section {
            AppTextField(placeholder: "Email", text: $text, icon: Image(systemName: "envelope.fill"), errorText: text.isValidEmail || text.isEmpty ? nil : "Email not valid") {
                
            }
            AppTextField(placeholder: "Password", text: $text, isSecure: true) {
                
            }
        } header: {
            Text("App TextaField")
        }
    }
}

struct AppComponentsUI_Previews: PreviewProvider {
    static var previews: some View {
        AppComponentsUI()
    }
}
