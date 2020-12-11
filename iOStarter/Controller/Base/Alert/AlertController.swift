//
//  AlertController.swift
//  iOStarter
//
//  Created by Crocodic Studio on 17/06/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class AlertController: ViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    static let appearance = AlertAppearance()
    
    let appearance = AlertController.appearance
    
    private var action: (() -> Void)?
    
    init() {
        super.init(nibName: "AlertView", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        negativeButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        positiveButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeAnimation))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAppearance() {
        alertView.backgroundColor = appearance.backgroundColor
        
        titleLabel?.textColor   = appearance.titleColor
        titleLabel?.font        = appearance.titleFont
        messageLabel?.textColor = appearance.messageColor
        messageLabel?.font      = appearance.messageFont
        
        negativeButton?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        negativeButton?.layer.borderWidth = 0.6
        negativeButton?.setTitleColor(appearance.dismissColor, for: UIControl.State())
        negativeButton?.setTitle(appearance.dismissText, for: UIControl.State())
        negativeButton?.titleLabel?.font  = appearance.buttonFont
        positiveButton?.layer.borderColor     = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        positiveButton?.layer.borderWidth     = 0.6
        positiveButton?.setTitleColor(appearance.okeColor, for: UIControl.State())
        positiveButton?.setTitle(appearance.okeText, for: UIControl.State())
        positiveButton?.titleLabel?.font      = appearance.buttonFont
        
        view.backgroundColor = appearance.overlayColor
    }
    
    override func setupView() {
        super.setupView()
        
        alertView.layer.cornerRadius = 15
        alertView.clipsToBounds      = true
        
        let blurEffect                  = UIBlurEffect(style: .light)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = self.alertView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alertView.addSubview(blurEffectView)
        alertView.sendSubviewToBack(blurEffectView)
        
        setupAppearance()
    }
    
    /// Show alert in view
    ///
    /// - Parameters:
    ///   - title: title in alert view (optional)
    ///   - message: message in alert view
    ///   - isCancelable: pass true to add cancelable button to dismiss without call oke function
    ///   - action: action when tap ok button (optional)
    func show(title: String?, message: String?, action: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        self.view.frame  = window.frame
        window.addSubview(self.view)

        let topVC = UIApplication.shared.topMostViewController()
        topVC?.addChild(self)
        
        titleLabel?.text     = title
        titleLabel?.isHidden = title == nil
        messageLabel?.text   = message
        
        self.action = action
        
        showAnimation()
    }
    
    /// Make animation when alert view show
    private func showAnimation() {
        alertView.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
        view.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// Submit close and call action
    func submitAction() {
        action?()
        closeAnimation()
    }
    
    /// Close action
    @objc private func action(_ button: UIButton) {
        if button == positiveButton {
            action?()
        }
        closeAnimation()
    }
    
    /// Make animation when alert view close
    @objc private func closeAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
    
}

extension AlertController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView == alertView || alertView.subviews.contains(touchView) {
                return false
            }
        }
        return true
    }
}

extension UIViewController {
    func presentAlert(title: String?, message: String?, action: (() -> Void)?) {
        let alert = AlertController()
        alert.show(title: title, message: message, action: action)
    }
}
