//
//  AppTextEditor.swift
//  iOStarter
//
//  Created by MBP2022_1 on 16/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import SwiftUI

struct AppTextView<Content: View>: View {
    
    let placeholder: String
    let text: Binding<String>
    let icon: Image?
    let trailingView: Content
    let errorText: String?
    
    @State private var isEditing = false
    
    private let textFieldHeight: CGFloat = 150
    private let textColor = UIColor.black
    private let normalColor = Color.primary
    private let activeColor = Color.accentColor
    private let font = UIFont.systemFont(ofSize: 14)
    
    init(placeholder: String, text: Binding<String>, icon: Image? = nil, errorText: String? = nil, @ViewBuilder trailingView: (() -> Content)) {
        self.placeholder = placeholder
        self.text = text
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
                HStack(alignment: .top) {
                    icon
                    textFieldView
                    trailingView
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
        UITextViewRepresentable(placeholder: placeholder, text: text) { isEditing in
            self.isEditing = isEditing
        }
        .font(font)
        .textColor(textColor)
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
    
}

struct AppTextViewView_Previews: View {
    @State private var text = ""
    
    var body: some View {
        AppTextView(placeholder: "Placeholder", text: $text, trailingView: {
            
        })
    }
}

struct AppTextView_Previews: PreviewProvider {
    static var previews: some View {
        AppTextViewView_Previews()
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
