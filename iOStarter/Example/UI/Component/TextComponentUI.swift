//
//  TextComponentUI.swift
//  iOStarter
//
//  Created by MBP2022_1 on 20/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct TextComponentUI: View {
    @State private var text = "Example"
    
    var body: some View {
        List {
            buildText()
            buildTextField()
            buildSecureTextField()
            buildRedactedText()
            buildTextEditor()
        }
        .navigationTitle(Text("Text"))
    }
    
    @ViewBuilder
    func buildText() -> some View {
        Section {
            Text(text)
        } header: {
            Text("Text")
        }
    }
    
    @ViewBuilder
    func buildTextField() -> some View {
        Section {
            TextField("Placehilder", text: $text) { isEditing in
                print(isEditing)
            }
        } header: {
            Text("TextField")
        }
    }
    
    @ViewBuilder
    func buildSecureTextField() -> some View {
        Section {
            SecureField("Password", text: $text)
        } header: {
            Text("SecureField")
        }
    }
    
    @ViewBuilder
    func buildRedactedText() -> some View {
        Section {
            Text(text)
                .redacted(reason: .placeholder)
        } header: {
            Text("Redacted Text")
        } footer: {
            Text("Best usage in detail for loading")
        }
    }
    
    @ViewBuilder
    func buildTextEditor() -> some View {
        Section {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    VStack {
                        Text("Write something...")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .opacity(0.6)
                        Spacer()
                    }
                }
                TextEditor(text: $text)
            }
        } header: {
            Text("TextEditor")
        }
    }
}

struct TextComponentUI_Previews: PreviewProvider {
    static var previews: some View {
        TextComponentUI()
    }
}
