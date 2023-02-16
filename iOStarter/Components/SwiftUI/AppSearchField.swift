//
//  AppSearchField.swift
//  iOStarter
//
//  Created by MBP2022_1 on 16/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct AppSearchField: View {
    let text: Binding<String>
    let onReturn: (() -> ())?
    
    init(text: Binding<String>, onReturn: (() -> ())? = nil) {
        self.text = text
        self.onReturn = onReturn
    }
    
    var body: some View {
        AppTextField(placeholder: L10n.search, text: text, icon: Image(systemName: "magnifyingglass"), trailingView: {
            if text.wrappedValue.isNotEmpty {
                Button {
                    text.wrappedValue = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }

        }, onReturn: onReturn)
    }
}

struct AppSearchFieldView_Previews: View {
    @State private var text = ""
    
    var body: some View {
        AppSearchField(text: $text)
    }
}

struct AppSearchField_Previews: PreviewProvider {
    static var previews: some View {
        AppSearchFieldView_Previews()
    }
}
