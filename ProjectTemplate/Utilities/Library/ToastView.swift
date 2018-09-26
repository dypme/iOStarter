//
//  ToastView.swift
//  Indomaret
//
//  Created by Crocodic MBP-2 on 4/12/18.
//  Copyright © 2018 Crocodic Studio. All rights reserved.
//

import UIKit

class ToastView: NSObject {
    /// Show your toast information
    ///
    /// - Parameter text: Text inside toast
    func show(text: String) {
        guard let view = UIApplication.shared.keyWindow else { return }
        let width = view.frame.width - 64
        let font = UIFont.systemFont(ofSize: 14)
        let textHeight = calculateHeight(withConstrainedWidth: width, font: font, string: text)
//        let text2Height = calculateHeight(withConstrainedWidth: width, font: font, string: "a\na")
        let height = textHeight // min(textHeight, text2Height)
        let label = UILabel(frame: CGRect(x: 12, y: 12, width: width, height: height))
        label.numberOfLines = 2
        label.text = text
        label.textColor = UIColor.white
        label.font = font
        label.textAlignment = .center
        label.sizeToFit()
        
        let widthView = view.frame.width - 40 > label.frame.width + 24 ? label.frame.width + 24 : view.frame.width - 40
        let heightView = label.frame.height + 24
        let popupToast = UIView(frame: CGRect(x: 20, y: view.bounds.maxY, width: widthView, height: heightView))
        popupToast.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        popupToast.clipsToBounds = true
        popupToast.alpha = 0
        popupToast.rounded()
        
        popupToast.addSubview(label)
        let x = (popupToast.frame.width / 2) - (label.frame.width / 2)
        let y = (popupToast.frame.height / 2) - (label.frame.height / 2)
        label.frame.origin = CGPoint(x: x, y: y)
        
        popupToast.center.x = view.center.x
        view.addSubview(popupToast)
        
        let isKeyboardVisible = KeyboardManager.shared.isVisible
        let keyboardHeight = isKeyboardVisible ? KeyboardManager.shared.keyboardFrame.height : 0
        
        var bottomSafeArea: CGFloat = 0
        if #available(iOS 11, *) {
            bottomSafeArea = !isKeyboardVisible ? view.safeAreaInsets.bottom : 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            popupToast.alpha = 1
            popupToast.frame.origin.y = view.bounds.maxY - popupToast.frame.height - 20 - bottomSafeArea - keyboardHeight
            popupToast.layoutIfNeeded()
        }) { (finish) in
            if finish {
                let interval = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: interval, execute: {
                    UIView.animate(withDuration: 0.25, animations: {
                        popupToast.alpha = 0
                    }, completion: { (done) in
                        if done {
                            popupToast.removeFromSuperview()
                        }
                    })
                })
            }
        }
    }
    
    /// Calculate height with specific width for text container
    ///
    /// - Parameters:
    ///   - width: Width used for calculate height
    ///   - string: Text for use calculate height based on length text
    /// - Returns: Height of view with specific width and text
    private func calculateHeight(withConstrainedWidth width: CGFloat, font: UIFont,  string: String) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension NSObject {
    /// Show your toast information in every where you want
    ///
    /// - Parameter text: Text inside toast
    func toastView(message: String) {
        ToastView().show(text: message)
    }
}
