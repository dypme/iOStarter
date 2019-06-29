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
    static var shared: Notify?
    
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
    
    /// Notification padding from view
    var padding: CGFloat = 6
    /// Image size
    private var imageSize: CGFloat = 20
    /// Top additional padding
    private var topPadding: CGFloat {
        var statusBarH: CGFloat
        if #available(iOS 11.0, *) {
            statusBarH = UIApplication.shared.keyWindow!.safeAreaInsets.top
        } else {
            statusBarH = UIApplication.shared.statusBarFrame.height
        }
        let topPadding: CGFloat = direction == .top && UIDevice.current.hasNotch ? statusBarH : 0
        return topPadding
    }
    /// Bottom additional padding
    private var bottomPadding: CGFloat {
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            if !isKeyboardShow {
                bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            }
        }
        return bottomPadding
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
        
        let swipeGesture       = UISwipeGestureRecognizer(target: self, action: #selector(hideNotify))
        swipeGesture.direction = direction == .top ? .up : .down
        self.addGestureRecognizer(swipeGesture)
        
        let blurEffect                  = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
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
            if direction == .bottom {
                if (endFrame?.origin.y)! >= screenMain.size.height {
                    self.frame.origin.y = screenMain.size.height - self.frame.size.height - padding - bottomPadding
                } else {
                    self.frame.origin.y = screenMain.size.height - (endFrame?.size.height)! - self.frame.size.height - padding - bottomPadding
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
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        
        // View container
        let containerW = screenW - (padding * 2)
        let containerY = topPadding + padding
        self.frame              = CGRect(x: padding, y: containerY, width: containerW, height: screenH)
        self.backgroundColor    = appearance.backgroundColor
        self.layer.cornerRadius = padding == 0 ? 0 : 10
        self.clipsToBounds      = true
        
        // Image view
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: imageSize, height: imageSize))
        imageView.contentMode        = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds      = true
        self.addSubview(imageView)
        if let myImage = self.image {
            imageView.image = myImage
        } else {
            imageView.image = Bundle.main.icon
        }
        
        // Title app name view
        let appName     = Bundle.main.appName
        let appNameW    = containerW - imageView.frame.maxX - 16
        let appNameH    = sizeHeight(with: appNameW, string: appName, font: UIFont.systemFont(ofSize: 12))
        let appNameX    = imageView.frame.maxX + 8
        let appNameY    = 8 + (imageSize / 2) - (appNameH / 2)
        let appNameRect = CGRect(x: appNameX, y: appNameY, width: appNameW, height: appNameH)
        let appNameLbl           = UILabel(frame: appNameRect)
        appNameLbl.numberOfLines = 1
        appNameLbl.font          = UIFont.systemFont(ofSize: 12)
        appNameLbl.textColor     = UIColor.black
        appNameLbl.textAlignment = .left
        appNameLbl.text          = appName
        self.addSubview(appNameLbl)
        
        // Title view
        let titleW          = containerW - 16
        let titleH1         = sizeHeight(with: titleW, string: title, font: appearance.titleFont)
        let titleH2         = sizeHeight(with: titleW, string: "a\na", font: appearance.titleFont)
        let titleH          = min(titleH1, titleH2)
        let titleX: CGFloat = 8
        let titleY          = max(appNameLbl.frame.maxY, imageView.frame.maxY) + 3
        let titleFrame      = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        let titleLbl           = UILabel(frame: titleFrame)
        titleLbl.text          = title
        titleLbl.font          = appearance.titleFont
        titleLbl.textColor     = appearance.titleColor
        titleLbl.numberOfLines = 2
        titleLbl.textAlignment = appearance.textAlign
        titleLbl.backgroundColor = .red
        self.addSubview(titleLbl)
        
        // Detail view
        let detailW          = titleW
        let detailH          = !detail.isEmpty ? sizeHeight(with: detailW, string: detail, font: appearance.detailFont) : 0
        let detailX: CGFloat = 8
        let detailY          = titleLbl.frame.maxY + 3
        let detailRect       = CGRect(x: detailX, y: detailY, width: detailW, height: detailH)
        let detailLbl        = UILabel(frame: detailRect)
        detailLbl.backgroundColor = .yellow
        if !detail.isEmpty {
            detailLbl.numberOfLines = 0
            detailLbl.font          = appearance.detailFont
            detailLbl.textColor     = appearance.detailColor
            detailLbl.textAlignment = appearance.textAlign
            detailLbl.text          = detail
            self.addSubview(detailLbl)
        }
        
        let contentHeight      = (detail.isEmpty ? titleLbl.frame.maxY : detailLbl.frame.maxY)
        self.frame.size.height = contentHeight + 8

        // exception when to long text
        if self.frame.size.height > (screenH / 4) && !detail.isEmpty {
            self.frame.size.height = (screenH / 4)
            let newDetailH         = (screenH / 4) - titleLbl.frame.maxY - 11
            detailLbl.frame        = CGRect(x: detailX, y: detailY, width: detailW , height: newDetailH)
        }
        
        if let window = UIApplication.shared.keyWindow {
            if let window = UIApplication.shared.keyWindow {
                if !UIDevice.current.hasNotch && direction == .top {
                    window.windowLevel = UIWindow.Level.statusBar + 1
                } else {
                    window.windowLevel = UIWindow.Level.normal
                }
            }
            
            Notify.shared?.hideNotify()
            Notify.shared = self
            
            window.addSubview(self)
            
            showAnimate(animated)
        }
    }
    
    /// Animation when notificatio show
    ///
    /// - Parameter animated: Pass true to animate the presentation; otherwise, pass false.
    private func showAnimate(_ animated: Bool) {
        let screenMain      = UIScreen.main
        let bottomFrame     = isKeyboardShow ? screenMain.bounds.height - keyboardFrame.height : screenMain.bounds.height
        
        let startDirection  = direction == .top ? -self.frame.height : bottomFrame
        let targetDirection = direction == .top ? (topPadding + padding) : (startDirection - self.frame.height - padding - bottomPadding)
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
        Notify.shared = nil
        timer.invalidate()
        
        let screenMain = UIScreen.main
        let bottomFrame = isKeyboardShow ? screenMain.bounds.height - keyboardFrame.height : screenMain.bounds.height
        
        let targetDirection = direction == .top ? (-self.frame.height - topPadding - padding) : (bottomFrame + padding + bottomPadding)
        UIView.animate(withDuration: 0.2, animations: { 
            self.frame.origin.y = targetDirection
            self.layoutIfNeeded()
        }) { (finished) in
            if let window = UIApplication.shared.keyWindow, Notify.shared == nil {
                window.windowLevel = UIWindow.Level.normal
            }
            self.removeFromSuperview()
        }
    }
    
    /// Calculate height with specific width for text container
    ///
    /// - Parameters:
    ///   - width: Width used for calculate height
    ///   - string: Text for use calculate height based on length text
    /// - Returns: Height of view with specific width and text
    private func sizeHeight(with width: CGFloat, string: String, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    /// Appearance data of notify
    class Appearance {
        var titleColor                 = UIColor.black
        var detailColor                = UIColor.black
        var titleFont: UIFont          = UIFont.boldSystemFont(ofSize: 14)
        var detailFont: UIFont         = UIFont.systemFont(ofSize: 12)
        var backgroundColor            = UIColor.white
        var textAlign: NSTextAlignment = .left
    }
    
}

extension Bundle {
    fileprivate var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles   = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon    = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    fileprivate var appName: String {
        let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        return name ?? ""
    }
}


extension UIDevice {
    fileprivate var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
}
