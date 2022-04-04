//
//  CheckBox.swift
//  iOStarter
//
//  Created by Crocodic Studio on 6/1/16.
//  Copyright © 2016 WahyuAdyP. All rights reserved.
//

import UIKit

@IBDesignable
/// UIButton subclass to make a check box button
class CheckBox: UIButton {
    
    /// Closure action when checkbox on tap
    private var onTap: ((_ checkBox: CheckBox, _ state: Bool) -> Void)? = nil
    
    /// Boolean value for detect state of checkbox
    @IBInspectable
    var isChecked: Bool = false {
        didSet {
            setImage()
        }
    }
    
    /// Color of checkbox
    @IBInspectable
    var color: UIColor? {
        didSet {
            setImage()
        }
    }
    
    /// Checkbox checked state image
    @IBInspectable
    var activeIcon: UIImage? {
        didSet {
            setImage()
        }
    }
    
    /// Checkbox unchecked state image
    @IBInspectable
    var inactiveIcon: UIImage? {
        didSet {
            setImage()
        }
    }
    
    /// The maximum number of lines to use for rendering checkbox text
    @IBInspectable
    var numberOfLinesText: Int = 1 {
        didSet {
            setImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMethod()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMethod()
    }
    
    private func setupMethod() {
        setImage()
        self.addTarget(self, action: #selector(switchState), for: .touchUpInside)
    }
    
    /// Set action when checkbox on tap
    ///
    /// - Parameter method: Closure action
    func setOnTap(_ method: ((_ checkBox: CheckBox, _ state: Bool) -> Void)?) {
        self.onTap = method
    }
    
    /// Change checkbox state
    ///
    /// - Parameter check: Boolean value for change state
    func setState(in check: Bool) {
        isChecked = check
        sendActions(for: .valueChanged)
        setImage()
    }

    /// Switch state with reversed from current state
    @objc private func switchState() {
        isChecked = !isChecked
        setState(in: isChecked)
        onTap?(self, isChecked)
    }
    
    /// Setting image that will show
    private func setImage() {
        tintColor = color ?? tintColor
        let newImage = (isChecked ? activeIcon : inactiveIcon)?.withRenderingMode(.alwaysTemplate)
        setImage(newImage, for: UIControl.State())
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.numberOfLines = numberOfLinesText
    }
    
}
