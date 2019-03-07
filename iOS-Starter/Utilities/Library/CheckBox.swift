//
//  CheckBox.swift
//  Tanda Mata
//
//  Created by Crocodic Studio on 6/1/16.
//  Copyright © 2016 Crocodic Studio. All rights reserved.
//

import UIKit

@IBDesignable
/// UIButton subclass to make a check box button
class CheckBox: UIButton {
    
    /// Closure action when checkbox on tap
    private var onTap: ((_ checkBox: CheckBox, _ state: Bool) -> Void)? = nil
    
    /// Boolean value for detect state of checkbox
    @IBInspectable var isChecked: Bool = false {
        didSet {
            setImage()
        }
    }
    
    /// Color of checkbox
    @IBInspectable var color: UIColor? {
        didSet {
            setImage()
        }
    }
    
    /// Checkbox checked state image
    @IBInspectable var checkedStateImage: UIImage? {
        didSet {
            setImage()
        }
    }
    
    /// Checkbox unchecked state image
    @IBInspectable var uncheckedStateImage: UIImage? {
        didSet {
            setImage()
        }
    }
    
    /// The maximum number of lines to use for rendering checkbox text
    @IBInspectable var numberOfLinesText: Int = 1 {
        didSet {
            setImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()
        self.addTarget(self, action: #selector(switchState), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImage()
        self.addTarget(self, action: #selector(switchState), for: .touchUpInside)
    }
    
    /// Set action when checkbox on tap
    ///
    /// - Parameter method: Closure action
    func setOnTap(_ method: @escaping (_ checkBox: CheckBox, _ state: Bool) -> Void) {
        self.onTap = method
    }
    
    /// Change checkbox state
    ///
    /// - Parameter check: Boolean value for change state
    func setState(in check: Bool) {
        self.isChecked = check
        self.sendActions(for: .valueChanged)
        setupTap(state: check)
    }

    /// Switch state with reversed from current state
    @objc private func switchState() {
        self.isChecked = !self.isChecked
        self.sendActions(for: .valueChanged)
        setupTap(state: self.isChecked)
        
        onTap?(self, isChecked)
    }
    
    /// Update image state
    ///
    /// - Parameter check: State that want change
    private func setupTap(state check: Bool) {
        setImage()
    }
    
    /// Setting image that will show
    private func setImage() {
        if let myColor = color {
            self.tintColor = myColor
        }
        let usedColor: UIColor = tintColor
        if isChecked {
            let image = self.checkedStateImage?.mask(color: usedColor)
            self.setImage(image, for: UIControl.State())
        } else {
            let image = self.uncheckedStateImage?.mask(color: usedColor)
            self.setImage(image, for: UIControl.State())
        }
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.numberOfLines = numberOfLinesText
    }
    
}

extension UIImage {
    /// Change image color
    ///
    /// - Parameter color: New color that used to change
    /// - Returns: New image with new color
    fileprivate func mask(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}
