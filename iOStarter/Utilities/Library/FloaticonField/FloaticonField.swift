//
//  FloaticonField.swift
//  TextFieldEffects
//
//  Created by Crocodic MBP-2 on 10/11/17.
//  Copyright © 2017 WahyuAdyP. All rights reserved.
//

import UIKit

@IBDesignable
/// UITextField with floating placeholder
class FloaticonField: FloaticonFieldEffects {
    
    /// Action responder of field
    enum EditActions {
        case cut, copy, paste, select, selectAll, delete
        var selector: Selector {
            switch self {
            case .cut:
                return #selector(UIResponderStandardEditActions.cut(_:))
            case .copy:
                return #selector(UIResponderStandardEditActions.copy)
            case .paste:
                return #selector(UIResponderStandardEditActions.paste)
            case .select:
                return #selector(UIResponderStandardEditActions.select)
            case .selectAll:
                return #selector(UIResponderStandardEditActions.selectAll)
            case .delete:
                return #selector(UIResponderStandardEditActions.delete)
            }
        }
    }
    
    /// Error action
    private var errorAction: (condition: ((String) -> Bool)?, execute: ((String) -> String?)?)? {
        didSet {
            if errorIcon == nil {
                errorIcon = UIImage.errorImage(fontSize: font?.pointSize ?? 12, color: errorColor)
            }
        }
    }
    
    /// Padding left to adjustment with setting of field
    private var insetLeft: CGFloat {
        if let leftView = leftView {
            return leftView.frame.size.width + 8
        }
        return 0
    }
    /// Padding right to adjustment with setting of field
    private var insetRight: CGFloat {
        if let rightView = rightView {
            return rightView.frame.size.width + 8
        }
        return 0
    }
    
    /// Set padding for field
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: insetLeft + paddingLeft, bottom: 0, right: insetRight + paddingRight)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // MARK: - Property
    /// Padding left of text, can change by user
    @IBInspectable
    var paddingLeft: CGFloat = 0
    /// Padding right of text, can change by user
    @IBInspectable
    var paddingRight: CGFloat = 0
    
    /// Boolean value for enabling floating placeholder
    @IBInspectable
    var isFloatingEnable: Bool = true
    
    /// Boolean value to make field required
    @IBInspectable
    var isFieldRequired: Bool = false
    
    /// Field color when become error
    @IBInspectable
    var errorColor: UIColor = UIColor.red
    
    /// Default icon of field
    @IBInspectable
    var icon: UIImage? {
        didSet {
            if let image = icon {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                self.leftView = imageView
                self.leftViewMode = .always
            } else {
                self.leftView = nil
                self.leftViewMode = .never
            }
        }
    }
    
    /// Error icon of field
    @IBInspectable
    var errorIcon: UIImage? {
        didSet {
            if let image = errorIcon {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                self.rightView = imageView
                self.rightViewMode = .always
            } else {
                self.rightView = nil
                self.rightViewMode = .never
            }
        }
    }
    
    // MARK: Line in field
    /// Inactive border color when field not editing
    @IBInspectable
    var borderInactiveColor: UIColor? = .lightGray {
        didSet {
            updateBorder()
        }
    }
    
    /// Active border color when field in editing
    @IBInspectable
    var borderActiveColor: UIColor? = .black {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable
    var placeholderColor: UIColor = .lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// Placeholder color when field editing (when placeholder floating)
    @IBInspectable
    var floatingPlaceholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable
    var placeholderFontScale: CGFloat = 0.78 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// Placeholder text when placeholder editing (when floating)
    @IBInspectable
    var floatingPlaceholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    /// Line border of field
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    /// Placeholder inset
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    /// Text field inset
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    /// Layer of active line border field
    private let activeBorderLayer = CALayer()
    /// Layer of inactive line border field
    private let inactiveBorderLayer = CALayer()
    /// Position placeholder when editing
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    /// Action response that allow used in field
    var allowActions: [EditActions] = []
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !allowActions.isEmpty {
            return allowActions.map{ $0.selector }.contains(action)
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        self.clipsToBounds = false
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.minimumScaleFactor = 0.5
        placeholderLabel.adjustsFontSizeToFitWidth = true
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
            self.placeholderLabel.font = self.placeholderFontFromFont(self.font!, resize: true)
            self.placeholderLabel.textColor = self.floatingPlaceholderColor
            if self.isFirstResponder {
                self.placeholderLabel.text = (self.floatingPlaceholder ?? self.placeholder)
                self.activeBorderLayer.backgroundColor = self.borderActiveColor?.cgColor
            } else {
                self.placeholderLabel.textColor = self.placeholderColor
                self.activeBorderLayer.backgroundColor = self.borderInactiveColor?.cgColor
            }
        }), completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
        
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: {
                self.placeholderLabel.font = self.placeholderFontFromFont(self.font!, resize: true)
                self.placeholderLabel.sizeToFit()
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                
                self.placeholderLabel.alpha = 0
                self.placeholderLabel.textColor = self.floatingPlaceholderColor
                self.placeholderLabel.text = (self.floatingPlaceholder ?? self.placeholder)
            }, completion: nil)
        }
        
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animate(withDuration: 0.4, animations: {
            let value = Int(truncating: NSNumber(value: self.isFloatingEnable))
            self.placeholderLabel.alpha = CGFloat(value)
        })
        
        let borderThick = isFirstResponder ? borderThickness.active : borderThickness.inactive
        activeBorderLayer.frame = rectForBorder(borderThick, isFilled: true)
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: ({
                self.placeholderLabel.alpha = 1
                self.placeholderLabel.textColor = self.placeholderColor
                self.placeholderLabel.text = self.placeholder
                
                self.placeholderLabel.font = self.placeholderFontFromFont(self.font!)
                self.placeholderLabel.sizeToFit()
                self.layoutPlaceholderInTextRect()
                
                self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor?.cgColor
                self.activeBorderLayer.backgroundColor = self.borderActiveColor?.cgColor
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        }
    }
    
    /// Update border width when editing or not
    private func updateBorder() {
        let color = isFirstResponder ? borderActiveColor : borderInactiveColor
        
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = color?.cgColor//borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = color?.cgColor//borderActiveColor?.cgColor
    }
    
    /// Update placeholder position & size when editing or not
    func updatePlaceholder() {
        placeholderLabel.frame = self.frame
        placeholderLabel.text = (text?.isEmpty)! ? placeholder : (floatingPlaceholder ?? placeholder)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || !text!.isEmpty {
            animateViewsForTextEntry()
        }
    }
    
    /// New placeholder font that adjust with position
    ///
    /// - Parameters:
    ///   - font: Current font
    ///   - resize: Boolean to make resize in current font
    /// - Returns: New font
    private func placeholderFontFromFont(_ font: UIFont, resize: Bool = false) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * (resize ? placeholderFontScale : 1))
        return smallerFont
    }
    
    /// Calculate new border width
    ///
    /// - Parameters:
    ///   - thickness: Width of current field state
    ///   - isFilled: Boolean to make border show or not
    /// - Returns: New border width
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    /// Layouting placholder in field
    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2 - (placeholderLabel.bounds.height)/2,
                                        width: placeholderLabel.bounds.width,
                                        height: placeholderLabel.bounds.height)// + placeholderInsets.y)
        if placeholderLabel.frame.width > self.bounds.width {
            placeholderLabel.frame.size.width = self.bounds.width
        }
        if placeholderLabel.frame.height > self.bounds.height {
            placeholderLabel.frame.size.height = self.bounds.height
        }
        let activeX = textAlignment == .right ? originX + insetRight : textAlignment == .center ? originX : originX - insetLeft
        activePlaceholderPoint = CGPoint(x: activeX, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
        
    }
    
    /// Set error condition and action of error condition in field
    ///
    /// - Parameters:
    ///   - condition: Error conditions
    ///   - execute: Error action when conditions are met
    func setError(when condition: @escaping ((String) -> Bool), execute: ((String) -> String?)? = nil) {
        errorAction = (condition, execute)
    }
    
    /// Show/ hide error message under field
    ///
    /// - Parameter text: Message error
    private func updateError(text: String?) {
        if let text = text {
            let height = calculateHeight(withConstrainedWidth: frame.width, string: text)
            errorLabel.frame = CGRect(x: 0, y: frame.height + 2, width: frame.width, height: height)
            let smallerFont = font?.withSize(font!.pointSize * placeholderFontScale)
            errorLabel.font = smallerFont
            errorLabel.text = text
            errorLabel.isHidden = text.isEmpty
            errorLabel.textColor = self.errorColor
            errorLabel.sizeToFit()
            errorLabel.frame.size.width = frame.width
        } else {
            errorLabel.isHidden = true
        }
        addSubview(errorLabel)
    }
    
    /// Calculate height of text in specific width
    ///
    /// - Parameters:
    ///   - width: Width size
    ///   - string: Text that want calculate
    /// - Returns: Actual height
    private func calculateHeight(withConstrainedWidth width: CGFloat, string: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [
            NSAttributedString.Key.font: placeholderFontFromFont(font!)!
            ], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// Boolean to check condition field showing or not
    ///
    /// - Parameter view: Container view that contain field
    /// - Returns: Boolean value
    private func isVisible(view: UIView) -> Bool {
        if view.window == nil {
            return false
        }
        
        var currentView: UIView = view
        while let superview = currentView.superview {
            
            if (superview.bounds).intersects(currentView.frame) == false {
                return false;
            }
            
            if currentView.isHidden {
                return false
            }
            
            currentView = superview
        }
        
        return true
    }
    
    /**
     The textfield has ended an editing session.
     */
    
    override func fieldDidBeginEditing() {
        animateViewsForTextEntry()
        
        updateError(text: nil)
    }
    
    override open func fieldDidEndEditing() {
        animateViewsForTextDisplay()
        
        if isFieldRequired {
            updateError(text: "Required")
            
            placeholderLabel.textColor = errorColor
            inactiveBorderLayer.backgroundColor = errorColor.cgColor
            activeBorderLayer.backgroundColor = errorColor.cgColor
        }
        
        if self.text!.isEmpty {
            return
        }
        
        guard let condition = (errorAction?.condition?(self.text!)), condition && isVisible(view: self) else {
            self.rightViewMode = .never
            updateBorder()
            updatePlaceholder()
            return
        }
        
        placeholderLabel.textColor = errorColor
        inactiveBorderLayer.backgroundColor = errorColor.cgColor
        activeBorderLayer.backgroundColor = errorColor.cgColor
        
        updateError(text: errorAction?.execute?(self.text!))
        
        self.rightViewMode = .always
    }
    
}

extension UIImage {
    /// Creating error image (red circle with "!" icon)
    ///
    /// - Parameters:
    ///   - fontSize: Font size of "!" icon
    ///   - color: Fill error color
    /// - Returns: Image of error
    fileprivate class func errorImage(fontSize: CGFloat, color: UIColor) -> UIImage {
        let diameter = fontSize * 4 / 3
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: color.contrastColor
        ]
        
        let myText = "!"
        let attributedString = NSAttributedString(string: myText, attributes: attributes)
        attributedString.draw(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}

extension UIColor {
    /// Make contrast color
    fileprivate var contrastColor: UIColor {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        if white > 0.51 {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
