//
//  UITextViewRepresentable.swift
//  iOStarter
//
//  Created by MBP2022_1 on 16/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import SwiftUI
import KMPlaceholderTextView

struct UITextViewRepresentable: UIViewRepresentable {
    typealias UIViewType = KMPlaceholderTextView
    
    private let placeholder: String
    @Binding private var text: String
    private let onEditingChanged: ((Bool) -> ())?
    
    private var textColor = UIColor.black
    private var font = UIFont.systemFont(ofSize: 14)
    private var keyboardType: UIKeyboardType = .default
    private var autocapitalizationType: UITextAutocapitalizationType = .none
    
    init(placeholder: String, text: Binding<String>, onEditingChanged: ((_ isEditing: Bool) -> ())? = nil) {
        self.placeholder = placeholder
        self.onEditingChanged = onEditingChanged
        self._text = text
    }
    
    func makeUIView(context: Context) -> KMPlaceholderTextView {
        let field = KMPlaceholderTextView()
        field.placeholder = placeholder
        field.text = text
        
        field.font = font
        field.textColor = textColor
        field.keyboardType = keyboardType
        field.autocapitalizationType = autocapitalizationType
        
        field.textContainer.lineFragmentPadding = 0
        field.textContainerInset = UIEdgeInsets.zero
        field.contentInset = UIEdgeInsets.zero
        
        field.delegate = context.coordinator
        return field
    }
    
    func updateUIView(_ uiView: KMPlaceholderTextView, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = textColor
        uiView.keyboardType = keyboardType
        uiView.autocapitalizationType = autocapitalizationType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: UITextViewRepresentable
        
        init(_ parent: UITextViewRepresentable) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onEditingChanged?(true)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.onEditingChanged?(false)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text ?? ""
        }
    }
    
}

extension UITextViewRepresentable {
    func textColor(_ color: UIColor) -> Self {
        var field = self
        field.textColor = color
        return field
    }
    
    func font(_ font: UIFont) -> Self {
        var field = self
        field.font = font
        return field
    }
    
    func keyboardType(_ type: UIKeyboardType) -> Self {
        var field = self
        field.keyboardType = type
        return field
    }
    
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        var field = self
        field.autocapitalizationType = type
        return field
    }
}
