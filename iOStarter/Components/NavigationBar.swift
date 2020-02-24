//
//  NavigationBar.swift
//  iOStarter
//
//  Created by Crocodic Studio on 30/08/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class NavAppearance {
    static let shared = NavAppearance()
    
    var titleFont: UIFont?             = nil
    var subtitleFont: UIFont?          = nil
    let titleColor: UIColor?           = nil
    let subtitleColor: UIColor?        = nil
    var textAlignment: NSTextAlignment = .center
}

class NavigationBar: UINavigationBar {

    private var navigationView: UIView?
    
    override var barTintColor: UIColor? {
        didSet {
            removeGradientColors()
            
            navigationView?.backgroundColor = self.barTintColor
            updateNavigationBar()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.barStyle = self.tintColor.isLight() == true ? .black : .default
        }
    }
    
    override var titleTextAttributes: [NSAttributedString.Key : Any]? {
        didSet {
            defaultTitleFont  = self.titleTextAttributes?[.font] as? UIFont
            defaultTitleColor = self.titleTextAttributes?[.foregroundColor] as? UIColor
        }
    }
    
    private var defaultTitleFont: UIFont?
    var titleFont: UIFont? = NavAppearance.shared.titleFont {
        didSet {
            updateTitle()
        }
    }
    
    private var defaultTitleColor: UIColor?
    var titleColor: UIColor? = NavAppearance.shared.titleColor {
        didSet {
            updateTitle()
        }
    }
    
    var fullRect: CGRect {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let newSize = CGSize(width: bounds.width, height: bounds.height + statusBarHeight)
        return CGRect(origin: .zero, size: newSize)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultTitleFont  = self.titleTextAttributes?[.font] as? UIFont
        defaultTitleColor = self.titleTextAttributes?[.foregroundColor] as? UIColor
        
        navigationView = UIView(frame: fullRect)
        navigationView?.backgroundColor = self.barTintColor
        
        updateNavigationBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        navigationView?.bounds = fullRect
        
        if let sublayer = navigationView?.layer.sublayers?.first(where: { $0.name == "bg_gradient" }) {
            sublayer.bounds = fullRect
        }
    }
    
    func setGradientColors(_ colors: [UIColor], direction: Direction) {
        removeGradientColors()
        
        let gradientLayer = CAGradientLayer(_frame: fullRect, _colors: colors, _direction: direction)
        gradientLayer.name = "bg_gradient"
        navigationView?.layer.insertSublayer(gradientLayer, at: 0)
        
        updateNavigationBar()
    }
    
    func removeGradientColors() {
        if let sublayer = layer.sublayers?.first(where: { $0.name == "bg_gradient" }) {
            sublayer.removeFromSuperlayer()
        }
    }
    
    private func updateNavigationBar() {
        let image = navigationView?.asImage()
        self.setBackgroundImage(image, for: .default)
    }
    
    private func updateTitle() {
        var attributeTitle: [NSAttributedString.Key : Any] = [:]
        
        if let data = self.defaultTitleFont {
            attributeTitle.updateValue(data, forKey: NSAttributedString.Key.font)
        }
        if let data = self.defaultTitleColor {
            attributeTitle.updateValue(data, forKey: NSAttributedString.Key.foregroundColor)
        }
        if let data = self.titleFont {
            attributeTitle.updateValue(data, forKey: NSAttributedString.Key.font)
        }
        if let data = self.titleColor {
            attributeTitle.updateValue(data, forKey: NSAttributedString.Key.foregroundColor)
        }
        
        self.titleTextAttributes = attributeTitle
    }
}

// MARK: Extension
extension UINavigationController {
    var navBar: NavigationBar? {
        return self.navigationBar as? NavigationBar
    }
}

fileprivate extension UIColor {
    
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best. I suggest to find out for yourself.
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.7) -> Bool? {
        let originalCGColor = self.cgColor
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}

fileprivate extension CAGradientLayer {
    convenience init(_frame: CGRect, _colors: [UIColor], _direction: Direction) {
        self.init()
        self.frame = _frame
        self.colors = []
        for color in _colors {
            self.colors?.append(color.cgColor)
        }
        switch _direction {
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
}

fileprivate extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
