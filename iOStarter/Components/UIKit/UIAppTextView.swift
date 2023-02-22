//
//  UIAppTextView.swift
//  iOStarter
//
//  Created by MBP2022_1 on 17/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit
import MaterialComponents
import L10n_swift

protocol UIAppTextViewDelegate: AnyObject {
    func textView(_ textView: UIAppTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

@IBDesignable
class UIAppTextView: UIControl {
    private let field: MDCBaseTextArea

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
    private var maximumNumberOfVisibleRows: CGFloat = 4
    private var preferredHeight: CGFloat = 100
    
    @IBInspectable
    var text: String? {
        set { field.textView.text = newValue }
        get { field.textView.text }
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
            field.textView.isSecureTextEntry = newValue
            setupAppearance()
        }
        get { field.textView.isSecureTextEntry }
    }
    
    var keyboardType: UIKeyboardType {
        set { field.textView.keyboardType = newValue }
        get { field.textView.keyboardType }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        set { field.textView.autocapitalizationType = newValue }
        get { field.textView.autocapitalizationType }
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
    
    weak var delegate: UIAppTextViewDelegate?
    
    // MARK: Initialize textfield
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }
    
    override init(frame: CGRect) {
        // TODO: Make sure text area style will use
        field = MDCOutlinedTextArea() // MDCFilledTextArea | MDCOutlinedTextArea
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        // TODO: Make sure text area style will use
        field = MDCOutlinedTextArea() // MDCFilledTextArea | MDCOutlinedTextArea
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
        field.textView.delegate = self
        trailingImageView.setTapGesture(target: self, action: #selector(switchVisibility))
    }
    
    @objc private func switchVisibility() {
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
    
    private func setupAppearance() {
        backgroundColor = .clear

        field.textView.textColor = textColor
        
        let isError = errorText?.isEmpty == true
        let standbyNormalColor = isError ? errorColor : normalColor
        
        field.textView.font = font
        
        field.label.textColor = placeholderColor
        field.label.font = font
        field.setNormalLabel(placeholderColor, for: .normal)
        
        field.leadingAssistiveLabel.text = errorText ?? helperText
        field.setLeadingAssistiveLabel(standbyNormalColor, for: .normal)
        field.setLeadingAssistiveLabel(standbyNormalColor, for: .editing)
        field.leadingAssistiveLabel.font = font.withSize(font.pointSize - 2)
        
        field.labelBehavior = .floats
        field.setFloatingLabel(standbyNormalColor, for: .normal)
        field.setFloatingLabel(activeColor, for: .editing)
        
        field.containerRadius = cornerRadius
        field.preferredContainerHeight = preferredHeight
        field.maximumNumberOfVisibleRows = maximumNumberOfVisibleRows
        
        if let filledTextArea = field as? MDCFilledTextArea {
            filledTextArea.setUnderlineColor(standbyNormalColor, for: .normal)
            filledTextArea.setUnderlineColor(activeColor, for: .editing)
            filledTextArea.setFilledBackgroundColor(.clear, for: .normal)
            filledTextArea.setFilledBackgroundColor(.clear, for: .editing)
            
            filledTextArea.leadingEdgePaddingOverride = 0
        } else if let outlinedTextArea = field as? MDCOutlinedTextArea {
            outlinedTextArea.setOutlineColor(standbyNormalColor, for: .normal)
            outlinedTextArea.setOutlineColor(activeColor, for: .editing)
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

extension UIAppTextView: IBL10n {
    @IBInspectable
    public var l10nText: String {
        get { self.messageForSetOnlyProperty() }
        set { self.field.textView.text = L10n_swift.L10n.shared.string(for: newValue) }
    }

    @IBInspectable
    public var l10nPlaceholder: String {
        get { self.messageForSetOnlyProperty() }
        set { self.placeholder = L10n_swift.L10n.shared.string(for: newValue) }
    }
}

extension UIAppTextView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        sendActions(for: .editingDidEnd)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendActions(for: .editingChanged)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        delegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}
