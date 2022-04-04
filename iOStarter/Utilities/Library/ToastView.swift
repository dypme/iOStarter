//
//  ToastView.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 4/12/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ToastView: UIView {
    private var padding: CGFloat = 20
    private var bottomPadding: CGFloat {
        isKeyboardVisible ? 0 : UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    private var isKeyboardVisible = false
    private var keyboardFrame = CGRect.zero
    
    init() {
        super.init(frame: .zero)
        
        let keyboardState = KeyboardStateListener.shared
        self.keyboardFrame = keyboardState.keyboardFrame
        self.isKeyboardVisible = keyboardState.isVisible
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Show your toast information
    ///
    /// - Parameter text: Text inside toast
    func show(text: String) {
        guard let view = UIApplication.shared.keyWindow else { return }
        let width = view.frame.width - 64
        let font = UIFont.systemFont(ofSize: 14)
        let height = calculateHeight(withConstrainedWidth: width, font: font, string: text)
        let label = UILabel(frame: CGRect(x: 12, y: 12, width: width, height: height))
        label.numberOfLines = 2
        label.text = text
        label.textColor = UIColor.white
        label.font = font
        label.textAlignment = .center
        label.sizeToFit()
        
        let widthView = view.frame.width - 40 > label.frame.width + 24 ? label.frame.width + 24 : view.frame.width - 40
        let heightView = label.frame.height + 24
        
        self.frame = CGRect(x: 20, y: view.bounds.maxY, width: widthView, height: heightView)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.clipsToBounds = true
        self.alpha = 0
        self.rounded()
        
        self.addSubview(label)
        let x = (self.frame.width / 2) - (label.frame.width / 2)
        let y = (self.frame.height / 2) - (label.frame.height / 2)
        label.frame.origin = CGPoint(x: x, y: y)
        
        self.center.x = view.center.x
        view.addSubview(self)
        
        let keyboardHeight = isKeyboardVisible ? keyboardFrame.height : 0
        let bottomSafeArea = !isKeyboardVisible ? view.safeAreaInsets.bottom : 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.frame.origin.y = view.bounds.maxY - self.frame.height - self.padding - bottomSafeArea - keyboardHeight
            self.layoutIfNeeded()
        }) { (finish) in
            if finish {
                let interval = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: interval, execute: {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.alpha = 0
                    }, completion: { (done) in
                        if done {
                            self.removeFromSuperview()
                        }
                    })
                })
            }
        }
    }
    
    override func didMoveToWindow() {
        if self.window != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    /// Make adjustment notification with keyboard
    ///
    /// - Parameter notification: Notification keyboard change frame
    @objc private func keyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            
            let animationCurveRaw = CUnsignedLong(truncating: animationCurveRawNSN!)
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let screenMain = UIScreen.main.bounds
            if (endFrame?.origin.y)! >= screenMain.size.height {
                self.frame.origin.y = screenMain.size.height - self.frame.size.height - padding - bottomPadding
            } else {
                self.frame.origin.y = screenMain.size.height - (endFrame?.size.height)! - self.frame.size.height - padding - bottomPadding
            }
            
            isKeyboardVisible = (endFrame?.origin.y)! < screenMain.size.height
            keyboardFrame = endFrame!
            
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.layoutIfNeeded() },
                                       completion: nil)
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
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }

}

extension NSObject {
    /// Show your toast information in every where you want
    ///
    /// - Parameter text: Text inside toast
    func presentToast(message: String) {
        ToastView().show(text: message)
    }
}
