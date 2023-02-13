//
//  AppButtonStyle.swift
//  iOStarter
//
//  Created by Macintosh on 05/07/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation
import SwiftUI

// TODO: Customize this style based on general usage button in app
struct AppButton: View {
    let action: (() -> ())
    let text: String
    let leadingIcon: Image?
    let trailingIcon: Image?
    
    init(action: @escaping () -> Void, text: String, leadingIcon: Image? = nil, trailingIcon: Image? = nil) {
        self.action = action
        self.text = text
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                leadingIcon
                Text(text)
                Spacer()
                trailingIcon
            }
        })
        .padding()
        .frame(maxWidth: .infinity, alignment: Alignment.leading)
        .font(Font.body.bold())
        .foregroundColor(.white)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(action: {
            
        }, text: "Hallo Button", leadingIcon: Image(systemName: "apple.logo"), trailingIcon: Image(systemName: "chevron.right"))
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
