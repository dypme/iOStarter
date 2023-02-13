//
//  AppTextField.swift
//  iOStarter
//
//  Created by MBP2022_1 on 26/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct AppTextField<Content: View>: View {
    
    let placeholder: String
    let text: Binding<String>
    let icon: Image?
    let trailingView: Content
    let errorText: String?
    let isSecure: Bool
    
    @State private var isEditing = false
    @State private var isSecureTextEntry: Bool
    
    private let textFieldHeight: CGFloat = 50
    private let textColor = UIColor.black
    private let normalColor = Color.primary
    private let activeColor = Color.accentColor
    private let font = UIFont.systemFont(ofSize: 14)
    
    init(placeholder: String, text: Binding<String>, isSecure: Bool = false, icon: Image? = nil, errorText: String? = nil, @ViewBuilder trailingView: (() -> Content)) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self._isSecureTextEntry = State(initialValue: isSecure)
        self.icon = icon
        self.trailingView = trailingView()
        self.errorText = errorText
    }
    
    private var isPlaceholderFloating: Bool {
        isEditing || (text.wrappedValue.count != 0)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .topLeading) {
                HStack {
                    icon
                    textFieldView
                    if isSecure {
                        visibilityButton
                    } else {
                        trailingView
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isEditing ? activeColor : normalColor, lineWidth: 1)
                    
                )
                .frame(height: textFieldHeight)
                placeholderView
            }
            
            if let errorText = errorText {
                errorTextView(errorText: errorText)
            }
        }
        .animation(.default)
    }
    
    @ViewBuilder
    private var textFieldView: some View {
        CustomTextField(placeholder: placeholder, text: text) { isEditing in
            self.isEditing = isEditing
        }
        .font(font)
        .textColor(textColor)
        .isSecureTextEntry(isSecureTextEntry)
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        Text(placeholder)
            .font(Font(font))
            .foregroundColor(isEditing ? activeColor : isPlaceholderFloating ? normalColor : Color.secondary)
            .background(Color(UIColor.systemBackground))
            .scaleEffect(isPlaceholderFloating ? 0.78 : 1.0)
            .padding()
            .offset(y: isPlaceholderFloating ? -24 : 0)
            .opacity(isPlaceholderFloating ? 1.0 : 0.0)
            .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func errorTextView(errorText: String) -> some View {
        Text(errorText)
            .font(Font.caption)
            .foregroundColor(.red)
            .frame(maxWidth: CGFloat.infinity, alignment: .leading)
            .padding([.leading, .trailing], 20)
    }
    
    @ViewBuilder
    private var visibilityButton: some View {
        Button {
            isSecureTextEntry.toggle()
        } label: {
            isSecureTextEntry ? Image(systemName: "eye.slash.fill") : Image(systemName: "eye.fill")
        }
        
    }
}

struct AppTextFieldView_Previews: View {
    @State private var text = ""
    
    var body: some View {
        AppTextField(placeholder: "Placeholder", text: $text, icon: Image(systemName: "magnifyingglass")) {
            
        }
    }
}

struct AppTextField_Previews: PreviewProvider {
    static var previews: some View {
        AppTextFieldView_Previews()
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
