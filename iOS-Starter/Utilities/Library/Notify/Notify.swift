//
//  Notify.swift
//  HalloWorld
//
//  Created by Crocodic MBP-2 on 11/6/17.
//  Copyright © 2017 Crocodic Studio. All rights reserved.
//

import UIKit

/// View to show notification
class Notify: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// Singleton Notify
    static var shared = Notify()
    
    /// Direction of notification will show
    ///
    /// - top: Notification show from top view
    /// - bottom: Notification show from bottom view
    enum Direction {
        case top
        case bottom
    }
    
    /// Title of notification
    var title = ""
    /// Detail message of notification
    var detail = ""
    /// Icon image of notification
    var image: UIImage? = nil
    /// Position notification will show
    var direction = Direction.top
    /// Automatically hide notification in duration
    var autoHide = true
    
    /// Action when notification will tap
    private var tapAction: (() -> Void)?
    /// Set tap action when user tap on this notify
    func setTapAction(_ action: (() -> Void)?) {
        self.tapAction = action
    }
    
    /// Setting appeance of notify
    let appearance = Appearance()
    
    /// Timer to hide notification in same duration
    private var timer = Timer()
    /// Check keyboard showing
    private var isKeyboardShow: Bool {
        return KeyboardManager.shared.isVisible
    }
    /// Keyboard frame
    private var keyboardFrame: CGRect {
        return KeyboardManager.shared.keyboardFrame
    }
    
    /// Initializes and returns a newly allocated view object with the specified title, detail, and image
    ///
    /// - Parameters:
    ///   - title: Title of notification
    ///   - detail: Detail text of notification
    ///   - image: Image icon in notification
    init(title: String, detail: String = "", image: UIImage? = nil) {
        super.init(frame: .zero)
        
        self.title = title
        self.detail = detail
        self.image = image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNotify))
        self.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideNotify))
        swipeGesture.direction = direction == .top ? .up : .down
        self.addGestureRecognizer(swipeGesture)
    }
    
    /// Initializes and returns a newly allocated view object
    init() {
        super.init(frame: .zero)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNotify))
        self.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideNotify))
        swipeGesture.direction = direction == .top ? .up : .down
        self.addGestureRecognizer(swipeGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        if self.window != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
    }
    
    /// Make adjustment notification with keyboard
    ///
    /// - Parameter notification: Notification keyboard change frame
    @objc private func keyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            keyboardFrame = endFrame!
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            
            let animationCurveRaw = CUnsignedLong(truncating: animationCurveRawNSN!)
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            let screenMain = UIScreen.main.bounds
            if direction == .bottom {
                if (endFrame?.origin.y)! >= screenMain.size.height {
                    self.frame.origin.y = screenMain.size.height - self.frame.size.height
                } else {
                    self.frame.origin.y = screenMain.size.height - (endFrame?.size.height)! - self.frame.size.height
                }
            }
            
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    /// Show notification
    ///
    /// - Parameter animated: Pass true to animate the presentation; otherwise, pass false.
    func show(animated: Bool = true) {
        let screenMain = UIScreen.main
        var statusBarHeight: CGFloat
        if #available(iOS 11.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow!.safeAreaInsets.top
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let addDirectionHeight: CGFloat = direction == .top ? statusBarHeight : 0
        
        self.frame = CGRect(x: 0, y: 0, width: screenMain.bounds.width, height: screenMain.bounds.height)
        let offset = CGSize(width: 0, height: direction == .top ? 2.0 : -2.0)
        self.shadow(offset: offset)
        self.backgroundColor = appearance.backgroundColor
        
        var imagePadding: CGFloat = 0
        if let myImage = self.image {
            let imageView = UIImageView(frame: CGRect(x: 20, y: 14 + addDirectionHeight, width: 40, height: 40))
            self.tag = 2
            imageView.image = myImage
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            
            imagePadding = 60
        }
        
        let titleWidth = screenMain.bounds.width - (imagePadding + 40)
        let textHeight = calculateHeight(withConstrainedWidth: titleWidth, string: title)
        let text2Height = calculateHeight(withConstrainedWidth: titleWidth, string: "a\na")
        let titleHeight = min(textHeight, text2Height)
        let titleLbl = UILabel(frame: CGRect(x: 20 + imagePadding, y: 14 + addDirectionHeight, width: titleWidth, height: titleHeight))
        titleLbl.tag = 0
        titleLbl.numberOfLines = 2
        titleLbl.font = appearance.titleFont
        titleLbl.textColor = appearance.titleColor
        titleLbl.textAlignment = image == nil ? appearance.textAlign : .left
        titleLbl.text = title
        self.addSubview(titleLbl)
        
        let detailWidth = screenMain.bounds.width - (imagePadding + 40)
        let detailHeight = !detail.isEmpty ? calculateHeight(withConstrainedWidth: detailWidth, string: detail) : 0
        let descriptionLbl = UILabel(frame: CGRect(x: 20 + imagePadding, y: titleHeight + titleLbl.frame.origin.y, width: detailWidth, height: detailHeight))
        if !detail.isEmpty {
            descriptionLbl.tag = 1
            descriptionLbl.numberOfLines = 0
            descriptionLbl.font = appearance.detailFont
            descriptionLbl.textColor = appearance.detailColor
            descriptionLbl.textAlignment = image == nil ? appearance.textAlign : .left
            descriptionLbl.text = detail
            self.addSubview(descriptionLbl)
        }
        
        var bottomSafeArea: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomSafeArea = direction == .top || isKeyboardShow ? 0 : UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        }
        self.frame.size.height = addDirectionHeight + titleHeight + 28 + detailHeight + bottomSafeArea
        
        // exception when to long text
        if self.frame.size.height > (screenMain.bounds.height / 8) - (addDirectionHeight + bottomSafeArea) {
            self.frame.size.height = (screenMain.bounds.height / 8) + addDirectionHeight
            let newHeight = self.frame.size.height - (titleHeight + titleLbl.frame.origin.y) - 14
            descriptionLbl.frame = CGRect(x: 20 + imagePadding, y: titleHeight + titleLbl.frame.origin.y, width: detailWidth, height: newHeight)
            
            self.frame.size.height = (screenMain.bounds.height / 8) + (addDirectionHeight + bottomSafeArea)
        }
        
        if let window = UIApplication.shared.keyWindow {
            Notify.shared.hideNotify()
            Notify.shared = self
            
            window.addSubview(self)
            
            showAnimate(animated)
        }
    }
    
    /// Animation when notificatio show
    ///
    /// - Parameter animated: Pass true to animate the presentation; otherwise, pass false.
    private func showAnimate(_ animated: Bool) {
        let screenMain = UIScreen.main
        let bottomFrame = isKeyboardShow ? screenMain.bounds.height - keyboardFrame.height : screenMain.bounds.height
        let startDirection = direction == .top ? -self.frame.height : bottomFrame
        let targetDirection = direction == .top ? 0 : (startDirection - self.frame.height)
        
        self.frame.origin.y = startDirection
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.y = targetDirection
            self.layoutIfNeeded()
        }) { (finished) in
            if self.autoHide {
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.hideNotify), userInfo: nil, repeats: true)
            }
        }
    }
    
    /// Hide notification and handle tap action
    @objc func tapNotify() {
        self.tapAction?()
        hideNotify()
    }
    
    /// Hide notification animation
    @objc func hideNotify() {
        timer.invalidate()
        let screenMain = UIScreen.main
        let bottomFrame = isKeyboardShow ? screenMain.bounds.height - keyboardFrame.height : screenMain.bounds.height
        let frameDirection = direction == .top ? -self.frame.height : bottomFrame
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.frame.origin.y = frameDirection
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    /// Calculate height with specific width for text container
    ///
    /// - Parameters:
    ///   - width: Width used for calculate height
    ///   - string: Text for use calculate height based on length text
    /// - Returns: Height of view with specific width and text
    func calculateHeight(withConstrainedWidth width: CGFloat, string: String) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: appearance.titleFont], context: nil)
        
        return ceil(boundingBox.height)
    }

    /// Appearance data of notify
    class Appearance {
        var titleColor = UIColor.black
        var detailColor = UIColor.black
        var titleFont: UIFont = FontFamily.ProximaNova.bold.font(size: 16)
        var detailFont: UIFont = FontFamily.ProximaNova.regular.font(size: 14)
        var backgroundColor = UIColor.white
        var textAlign: NSTextAlignment = .center
    }
    
}
