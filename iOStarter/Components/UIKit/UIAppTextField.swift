//
//  UIAppTextField.swift
//  iOStarter
//
//  Created by MBP2022_1 on 17/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import MaterialComponents
import L10n_swift

protocol UIAppTextFieldDelegate: AnyObject {
    func textField(_ textField: UIAppTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

@IBDesignable
class UIAppTextField: UIControl {
    private let field: MDCBaseTextField
    
    private var trailingImageView = UIImageView()
    private var loadingView: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()
    
    private var textColor = UIColor.black
    private var placeholderColor = UIColor.placeholderText
    private var normalColor = UIColor.placeholderText
    private var activeColor = Asset.Colors.accentColor.color
    private var errorColor = UIColor.red
    private var font = UIFont.systemFont(ofSize: 14)
    private var cornerRadius: CGFloat = 0
    private var isSecureTextEntry = false
    private var preferredHeight: CGFloat = 50
    
    @IBInspectable
    var text: String? {
        set { field.text = newValue }
        get { field.text }
    }
    
    @IBInspectable
    var placeholder: String? {
        set {
            field.placeholder = newValue
            field.label.text = newValue
        }
        get { field.placeholder }
    }
    
    @IBInspectable
    var helperText: String? = nil {
        didSet { setupAppearance() }
    }
    
    @IBInspectable
    var icon: UIImage? = nil {
        didSet { setupAppearance() }
    }
    
    @IBInspectable
    var isSecuredField: Bool {
        set {
            field.isSecureTextEntry = newValue
            setupAppearance()
        }
        get { field.isSecureTextEntry }
    }
    
    var keyboardType: UIKeyboardType {
        set { field.keyboardType = newValue }
        get { field.keyboardType }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        set { field.autocapitalizationType = newValue }
        get { field.autocapitalizationType }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.isUserInteractionEnabled = !isLoading
            if isLoading {
                loadingView.startAnimating()
            } else {
                loadingView.stopAnimating()
            }
            setupAppearance()
        }
    }
    
    var errorText: String? = nil {
        didSet { setupAppearance() }
    }
    
    weak var delegate: UIAppTextFieldDelegate?

    // MARK: Initialize textfield
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }
    
    override init(frame: CGRect) {
        // TODO: Make sure text field style will use
        field = MDCFilledTextField() // MDCFilledTextField | MDCOutlinedTextField
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        // TODO: Make sure text field style will use
        field = MDCFilledTextField() // MDCFilledTextField | MDCOutlinedTextField
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: preferredHeight)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    /// Initialize setup text field
    private func setup() {
        field.translatesAutoresizingMaskIntoConstraints = false
        addSubview(field)
        field.topAnchor.constraint(equalTo: topAnchor).isActive = true
        field.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        field.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupMethod()
        setupAppearance()
    }
    
    
    private func setupMethod() {
        field.delegate = self
        field.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        trailingImageView.setTapGesture(target: self, action: #selector(switchVisibility))
    }
    
    @objc private func editingDidEnd() {
        sendActions(for: .editingDidEnd)
    }
    
    @objc private func editingChanged() {
        sendActions(for: .editingChanged)
    }
    
    @objc private func switchVisibility() {
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        
        field.textColor = textColor
        
        let isError = errorText?.isEmpty == true
        let standbyNormalColor = isError ? errorColor : normalColor
        
        field.font = font
        
        field.label.textColor = placeholderColor
        field.label.font = font
        field.setNormalLabelColor(placeholderColor, for: .normal)
        
        field.leadingAssistiveLabel.text = errorText ?? helperText
        field.setLeadingAssistiveLabelColor(standbyNormalColor, for: .normal)
        field.setLeadingAssistiveLabelColor(standbyNormalColor, for: .editing)
        field.leadingAssistiveLabel.font = font.withSize(font.pointSize - 2)
        
        field.labelBehavior = .floats
        field.setFloatingLabelColor(standbyNormalColor, for: .normal)
        field.setFloatingLabelColor(activeColor, for: .editing)
        
        field.containerRadius = cornerRadius
        
        if let filledTextField = field as? MDCFilledTextField {
            filledTextField.setUnderlineColor(standbyNormalColor, for: .normal)
            filledTextField.setUnderlineColor(activeColor, for: .editing)
            
            filledTextField.setFilledBackgroundColor(.clear, for: .normal)
            filledTextField.setFilledBackgroundColor(.clear, for: .editing)
            
            filledTextField.leadingEdgePaddingOverride = 0
        } else if let outlinedTextField = field as? MDCOutlinedTextField {
            outlinedTextField.setOutlineColor(standbyNormalColor, for: .normal)
            outlinedTextField.setOutlineColor(activeColor, for: .editing)
        }
        
        if isSecuredField {
            trailingImageView.image = isSecureTextEntry ? UIImage(systemName: "eye.slash.fill") : UIImage(systemName: "eye.fill")
        } else {
            trailingImageView.image = icon
        }
        trailingImageView.sizeToFit()
        trailingImageView.isUserInteractionEnabled = isSecuredField
        
        field.trailingView = isLoading ? loadingView : trailingImageView
        field.trailingViewMode = trailingImageView.image != nil || isSecuredField || isLoading ? .always : .never
    }
    
}

extension UIAppTextField: IBL10n {
    @IBInspectable
    public var l10nText: String {
        get { self.messageForSetOnlyProperty() }
        set { self.field.text = L10n_swift.L10n.shared.string(for: newValue) }
    }

    @IBInspectable
    public var l10nPlaceholder: String {
        get { self.messageForSetOnlyProperty() }
        set { self.placeholder = L10n_swift.L10n.shared.string(for: newValue) }
    }
}

extension UIAppTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
