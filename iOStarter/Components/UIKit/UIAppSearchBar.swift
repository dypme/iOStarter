//
//  UIAppSearchBar.swift
//  iOStarter
//
//  Created by MBP2022_1 on 20/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

protocol UIAppSearchBarDelegate: AnyObject {
    func searchBar(_ searchBar: UIAppSearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func searchBarSearchButtonClicked(_ searchBar: UIAppSearchBar)
}

@IBDesignable
class UIAppSearchBar: UIControl {
    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .search
        return field
    }()

    private let searchIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.isHidden = true
        return button
    }()
    
    private var textColor = UIColor.black
    private var font = UIFont.systemFont(ofSize: 14)
    private var cornerRadius: CGFloat = 10
    private var borderWidth: CGFloat = 1
    private var borderColor = UIColor.lightGray
    private var preferredHeight: CGFloat = 50
    
    @IBInspectable
    var text: String? {
        set {
            textField.text = newValue
            clearButton.isHidden = newValue?.isEmpty == true
        }
        get { textField.text }
    }
    
    @IBInspectable
    var placeholder: String? {
        set { textField.placeholder = newValue }
        get { textField.placeholder }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        set { textField.autocapitalizationType = newValue }
        get { textField.autocapitalizationType }
    }
    
    var keyboardType: UIKeyboardType {
        set { textField.keyboardType = newValue }
        get { textField.keyboardType }
    }
    
    weak var delegate: UIAppSearchBarDelegate?
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: preferredHeight)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Initialize setup text field
    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [searchIconView, textField, clearButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupMethod()
        setupAppearance()
    }
    
    private func setupMethod() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    }
    
    @objc private func editingDidEnd() {
        sendActions(for: .editingDidEnd)
    }
    
    @objc private func editingChanged() {
        sendActions(for: .editingChanged)
    }
    
    private func setupAppearance() {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        textField.textColor = textColor
        textField.font = font
    }
    
    @objc private func clearText() {
        text = ""
    }

}

extension UIAppSearchBar: UITextFieldDelegate, UISearchBarDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.searchBar(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarSearchButtonClicked(self)
        return true
    }
}
