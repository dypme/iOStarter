//
//  UITextFieldRepresentable.swift
//  iOStarter
//
//  Created by MBP2022_1 on 30/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import SwiftUI

struct UITextFieldRepresentable: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    private let placeholder: String
    @Binding private var text: String
    private let onEditingChanged: ((Bool) -> ())?
    
    private var textColor = UIColor.black
    private var font = UIFont.systemFont(ofSize: 14)
    private var isSecureTextEntry = false
    private var keyboardType: UIKeyboardType = .default
    private var autocapitalizationType: UITextAutocapitalizationType = .none
    
    init(placeholder: String, text: Binding<String>, onEditingChanged: ((_ isEditing: Bool) -> ())? = nil) {
        self.placeholder = placeholder
        self.onEditingChanged = onEditingChanged
        self._text = text
    }
    
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.text = text
        
        field.font = font
        field.textColor = textColor
        field.isSecureTextEntry = isSecureTextEntry
        field.keyboardType = keyboardType
        field.autocapitalizationType = autocapitalizationType
        
        field.delegate = context.coordinator
        field.addTarget(context.coordinator, action: #selector(Coordinator.textEditingChanged(_:)), for: .editingChanged)
        return field
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = textColor
        uiView.isSecureTextEntry = isSecureTextEntry
        uiView.keyboardType = keyboardType
        uiView.autocapitalizationType = autocapitalizationType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: UITextFieldRepresentable
        
        init(_ parent: UITextFieldRepresentable) {
            self.parent = parent
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.onEditingChanged?(true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onEditingChanged?(false)
        }
        
        @objc func textEditingChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
    
}

extension UITextFieldRepresentable {
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
    
    func isSecureTextEntry(_ bool: Bool) -> Self {
        var field = self
        field.isSecureTextEntry = bool
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
