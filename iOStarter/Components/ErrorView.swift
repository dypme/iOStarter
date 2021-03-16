//
//  ErrorView.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var messageLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var refreshBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Muat Ulang", for: UIControl.State())
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.backgroundColor = .red
        return button
    }()
    
    private var image: UIImage?
    private var message: String
    private var tapReload: (() -> Void)?
    
    /// Initialize error view
    /// - Parameters:
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - action: Action to reload fetch data while error occur
    init(image: UIImage? = nil, message: String, reloadAction action: (() -> Void)? = nil, tag: Int = 1431) {
        self.image = image
        self.message = message
        self.tapReload = action
        
        super.init(frame: .zero)
        
        self.tag = tag
        
        setupMethod()
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let hStackView = UIStackView(arrangedSubviews: [imageView, messageLbl, refreshBtn])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .vertical
        hStackView.alignment = .center
        hStackView.spacing = 20
        self.addSubview(hStackView)
        
        hStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 40).isActive = true
        hStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 40).isActive = true
        hStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 40).isActive = true
        hStackView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: 40).isActive = true
        
        hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        
        refreshBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        refreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        refreshBtn.addTarget(self, action: #selector(reload(_:)), for: .touchUpInside)
    }
    
    func setupView() {
        imageView.image = image
        imageView.isHidden = image == nil
        
        messageLbl.text = message
        
        refreshBtn.isHidden = tapReload == nil
        
        self.isUserInteractionEnabled = !refreshBtn.isHidden
        self.backgroundColor = .clear
        
        refreshBtn.rounded(value: 20)
    }
    
    private func setContentConstraint(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Show error view in view
    ///
    /// - Parameters:
    ///   - aView: View that will add error view
    func show(in view: UIView) {
        view.addSubview(self)
        setContentConstraint(in: view)
    }
    
    /// Reload button function action
    ///
    /// - Parameter button: Sender button
    @objc func reload(_ button: UIButton) {
        self.removeFromSuperview()
        tapReload?()
    }

}

extension UIView {
    /// Show error view in front view
    ///
    /// - Parameters:
    ///   - frame: Size & position of error view
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - tapReload: Action to reload fetch data while error occur
    ///   - tag: Mark of error view in superview
    func setErrorView(image: UIImage? = nil, message: String, tapReload: (() -> Void)?, tag: Int = 1431) {
        let topView = self.superview ?? self
        
        let errorView = ErrorView(image: image, message: message, reloadAction: tapReload, tag: tag)
        
        if !topView.subviews.contains(where: { $0.tag == tag }) {
            errorView.show(in: topView)
        }
    }
    
    /// Stop animating activity indicator in superview of current view
    /// - Parameter tag: Mark of error view in superview
    func removeErrorView(tag: Int = 1431) {
        let topView = self.superview ?? self
        
        if let errorView = topView.subviews.first(where: { $0.tag == tag }) as? ErrorView {
            errorView.removeFromSuperview()
        }
    }
}
