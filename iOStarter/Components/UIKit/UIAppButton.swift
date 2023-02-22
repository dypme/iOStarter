//
//  UIAppButton.swift
//  iOStarter
//
//  Created by MBP2022_1 on 17/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

@IBDesignable
class UIAppButton: UIControl {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private var leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private var trailingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private var titleColor = UIColor.white
    private var font = UIFont.boldSystemFont(ofSize: 14)
    private var color = Asset.Colors.accentColor.color
    private var cornerRadius: CGFloat = 10
    private var preferredHeight: CGFloat = 50
    
    @IBInspectable
    var title: String? {
        set { titleLabel.text = newValue }
        get { titleLabel.text }
    }
    
    @IBInspectable
    var leadingIcon: UIImage? {
        set {
            leadingImageView.image = newValue
            leadingImageView.isHidden = newValue == nil
        }
        get { leadingImageView.image }
    }
    
    @IBInspectable
    var trailingIcon: UIImage? {
        set {
            trailingImageView.image = newValue
            trailingImageView.isHidden = newValue == nil
        }
        get { trailingImageView.image }
    }
    
    init(title: String, leadingIcon: UIImage? = nil, trailingIcon: UIImage? = nil) {
        super.init(frame: CGRect.zero)
        
        self.title = title
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
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
    
    func setup() {
        isMultipleTouchEnabled = false
        backgroundColor = color
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        titleLabel.textColor = titleColor
        titleLabel.font = font
        
        setupLayout()
    }
    
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [leadingImageView,  titleLabel, trailingImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
        super.touchesEnded(touches, with: event)
    }
}
