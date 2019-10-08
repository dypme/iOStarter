//
//  Extension.swift
//  SCG Jayamix
//
//  Created by Crocodic MBP-2 on 5/30/17.
//  Copyright © 2017 Crocodic Studio. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case left
    case right
    case top
    case bottom
}

extension CAGradientLayer {
    /// Initailize gradient layer with specific frame, colors for gradient, and direction of gradient
    ///
    /// - Parameters:
    ///   - frame: Layer poisiton and size
    ///   - colors: Gradient layer color
    ///   - direction: Direction gradient layer color
    convenience init(frame: CGRect, colors: [UIColor], direction: Direction) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        switch direction {
        case .top:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .bottom:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        case .left:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        case .right:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        }
    }
    
    /// Set rendering layer into image
    ///
    /// - Returns: UIimage result from rendering
    func gradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

protocol NavigationControllerBackButtonDelegate {
    /// Handle function for default back button item in navigation controller
    ///
    /// - Returns: Pass true if want default back button enable, Pass false if want default back button disable
    func viewControllerShouldPopOnBackButton() -> Bool
}
extension UINavigationController {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        if self.viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        
        var shouldPop = true
        if let viewController = self.topViewController as? NavigationControllerBackButtonDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackButton()
        }
        if (shouldPop) {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        view.alpha = 1.0
                    })
                }
            }
            
        }
        
        return false
    }
}

extension UIView {
    /// Create tap gesture in view
    ///
    /// - Parameters:
    ///   - target: An object that is the recipient of action messages sent by the receiver when it recognizes a gesture. nil is not a valid value.
    ///   - action: A selector that identifies the method implemented by the target to handle the gesture recognized by the receiver. The action selector must conform to the signature described in the class overview. NULL is not a valid value.
    func setTapGesture(target: Any?, action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    /// Make view rounded with maximum radius
    func circle() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) / 2
    }
    
    /// Make view rounded with specific radius value
    ///
    /// - Parameter value: Value of radius want rounded
    func rounded(value: CGFloat = 8) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = value
    }
    
    /// Make shadow in view
    ///
    /// - Parameters:
    ///   - color: Color of shadow
    ///   - offset: Position of shadow in view
    func shadow(color: UIColor = UIColor.lightGray, offset: CGSize = CGSize(width: 0, height: 2.0)) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
    }
    
    /// Remove shadow
    func removeShadow() {
        self.layer.shadowOpacity = 0.0
    }
    
    /// Make line border in view
    ///
    /// - Parameters:
    ///   - color: Color of border line
    ///   - width: Width of border line
    func border(color: UIColor = UIColor.black, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// Make dashed border
    ///
    /// - Parameters:
    ///   - color: Color of dashed border
    ///   - width: Width of dashed border
    func dashedBorder(color: UIColor = UIColor.black, width: CGFloat = 1) {
        self.layoutIfNeeded()
        if let sublayers = layer.sublayers {
            for aLayer in sublayers {
                if aLayer.name == "dashedBorder" {
                    aLayer.removeFromSuperlayer()
                }
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "dashedBorder"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Unlinks all view from its superview and its window, and removes all from the responder chain
    func removeAllSubviews() {
        for aView in subviews {
            aView.removeFromSuperview()
        }
    }
    
    /// Create background color gradient for view
    ///
    /// - Parameters:
    ///   - colors: Color of gradient layer
    ///   - direction: Direction of gradient layer
    func backgroundGradient(colors: [UIColor], direction: Direction = .top) {
        self.layoutIfNeeded()
        if let sublayers = layer.sublayers {
            for aLayer in sublayers {
                if aLayer.name == "gradientBG" {
                    aLayer.removeFromSuperlayer()
                }
            }
        }
        
        self.backgroundColor = colors.first
        let gradientLayer = CAGradientLayer(frame: bounds, colors: colors, direction: direction)
        gradientLayer.name = "gradientBG"
        gradientLayer.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Connect relation of each field so, return field can use to move in every connected fields
    ///
    /// - Parameter fields: All field that will connect
    class func connect(fields: [UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}

extension UIViewController {
    /// Handle custom back button without manual code
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let backBtn = self.navigationItem.leftBarButtonItem {
            if backBtn.tag == 0 {
                backBtn.target = self
                backBtn.action = #selector(backNavBar(_:))
            }
        }
    }
    
    /// Function back to presenting viewcontroller
    ///
    /// - Parameter barButtonItem: Sender of button bar item
    @objc private func backNavBar(_ barButtonItem: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// Show default simple Alert
    ///
    /// - Parameters:
    ///   - title: Title of alert
    ///   - message: Message of alert
    ///   - handler: Action if alert dismissed
    func simpleAlert(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(ok)
        self.present(alert, animated: true) {
            
        }
    }
}

extension UIApplication {
    /// Status bar background view
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UITextField {
    /// Set placeholder color of UITextField
    ///
    /// - Parameter color: Color of placeholder
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                             attributes: attributeString)
    }
}

extension Date {
    /// Formatting string from date
    ///
    /// - Parameter format: Format date want. Check this [link](http://nsdateformatter.com/) for all about formatting date in swift
    /// - Returns: String of date after formatting
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UIImage {
    /// Render image with specific background color and size
    ///
    /// - Parameters:
    ///   - color: Color of background image
    ///   - size: Size of image
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// Uncompressed image data
    var uncompressedPNGData: Data?    { return self.pngData()!       }
    /// Uncompressed image data without transparent in image
    var highestQualityJPEGData: Data? { return self.jpegData(compressionQuality: 1.0)  }
    /// Compressed image data to 75% of original image without transparent in image
    var highQualityJPEGData: Data?    { return self.jpegData(compressionQuality: 0.75) }
    /// Compressed image data to 50% of original image without transparent in image
    var mediumQualityJPEGData: Data?  { return self.jpegData(compressionQuality: 0.5)  }
    /// Compressed image data to 25% of original image without transparent in image
    var lowQualityJPEGData: Data?     { return self.jpegData(compressionQuality: 0.25) }
    /// Compressed image data to 0% of original image without transparent in image
    var lowestQualityJPEGData:Data?   { return self.jpegData(compressionQuality: 0.0)  }
    
    /// Change size image to new size
    ///
    /// - Parameter newSize: New size will be applied
    /// - Returns: Image with new size
    func resize(to newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UITableView {
    /// Bottom of tableview to show/ hide load more indicator
    func activityLoadMore(isHidden: Bool) {
        if !isHidden {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.layoutIfNeeded()
                
                let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
                let activityId = UIActivityIndicatorView(style: .gray)
                activityId.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                activityId.startAnimating()
                bottomView.addSubview(activityId)
                
                bottomView.tag = 1238
                
                activityId.center = bottomView.center
                
                self.tableFooterView = bottomView
            }
        } else {
            if self.tableFooterView?.tag == 1238 {
                self.tableFooterView = nil
            }
        }
    }
}

extension String {
    /// Check email validity
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// Check phone number validity
    var isValidPhone: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && res.phoneNumber == self
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Change date format to new format date
    ///
    /// - Parameters:
    ///   - old: Current format
    ///   - new: Format that will change
    /// - Returns: New format date
    func dateChange(from old: String, to new: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = old
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = new
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    /// Convert string format date to Date data type
    ///
    /// - Parameter format: Current format string date
    /// - Returns: Date from string
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LocalizeHelper.shared.locale
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}

extension Int {
    /// Change integer data type into string format decimal
    var asDecimal: String {
        let formatter = NumberFormatter()
        formatter.locale = LocalizeHelper.shared.locale
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(integerLiteral: self))
        return string!
    }
    
    /// Change integer into boolean data type
    var toBool: Bool {
        return Bool(truncating: NSNumber(value: self))
    }
}

extension Int64 {
    /// Change integer64 data type into string format decimal
    var asDecimal: String {
        let formatter = NumberFormatter()
        formatter.locale = LocalizeHelper.shared.locale
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value: self))
        return string!
    }
}

extension Bool {
    /// Change boolean into integer data type
    var toInt: Int {
        return Int(truncating: NSNumber(value: self))
    }
}
