//
//  AlertSheetController.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 10/12/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import UIKit

class AlertSheetController: ViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    
    private var overlayView: UIView!
    var shouldResignOnTouchOutside: Bool = true {
        didSet {
            overlayView?.isUserInteractionEnabled = shouldResignOnTouchOutside
            alertView?.gestureRecognizers?.forEach({ (gesture) in
                gesture.isEnabled = shouldResignOnTouchOutside
            })
        }
    }
    
    static let appearance = AlertAppearance()
    
    var appearance = AlertSheetController.appearance
    
    private var action: (() -> Void)?
    
    private var parentController: UIViewController?
    func setParentController(_ controller: UIViewController) {
        parentController = controller
    }
    
    init() {
        super.init(nibName: "AlertSheetView", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        negativeButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        positiveButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        overlayView = UIView(frame: self.view.frame)
        overlayView.backgroundColor  = .clear
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlayView)
        view.sendSubviewToBack(overlayView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        overlayView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        alertView.addGestureRecognizer(panGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupAppearance() {
        alertView.layer.cornerRadius = 15
        alertView.backgroundColor = appearance.backgroundColor
        
        titleLabel?.textColor   = appearance.titleColor
        titleLabel?.font        = appearance.titleFont
        messageLabel?.textColor = appearance.messageColor
        messageLabel?.font      = appearance.messageFont
        
        negativeButton?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        negativeButton?.layer.borderWidth = 0.6
        negativeButton?.setTitleColor(appearance.dismissColor, for: UIControl.State())
        negativeButton?.titleLabel?.font  = appearance.buttonFont
        positiveButton?.layer.borderColor     = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        positiveButton?.layer.borderWidth     = 0.6
        positiveButton?.setTitleColor(appearance.okeColor, for: UIControl.State())
        positiveButton?.titleLabel?.font      = appearance.buttonFont
        
        overlayView.backgroundColor          = appearance.overlayColor
        overlayView.isUserInteractionEnabled = shouldResignOnTouchOutside
        
        alertView.gestureRecognizers?.forEach({ (gesture) in
            gesture.isEnabled = shouldResignOnTouchOutside
        })
        
        view.backgroundColor        = .clear
    }
    
    override func setupView() {
        super.setupView()
        
        alertView.clipsToBounds      = false
        
        if appearance.isBlurContainer {
            let blurEffect                  = UIBlurEffect(style: .light)
            let blurEffectView              = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame            = self.alertView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            alertView.addSubview(blurEffectView)
            alertView.sendSubviewToBack(blurEffectView)
        }
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 40, width: alertView.frame.width, height: alertView.frame.height + 80))
        bottomView.backgroundColor = appearance.backgroundColor
        if #available(iOS 11.0, *) {
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            bottomView.frame.size.height += bottomPadding
        }
        alertView.addSubview(bottomView)
        alertView.sendSubviewToBack(bottomView)
        
        setupAppearance()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.view.frame.origin.y = 0
            } else {
                self.view.frame.origin.y = -(endFrame?.size.height ?? 0.0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
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
        
        if parentController == nil {
            parentController = UIApplication.shared.topMostViewController()
        }
        if let alerts = parentController?.children.compactMap({ $0 as? AlertSheetController }) {
            alerts.forEach { (controller) in
                controller.close()
            }
        }
        parentController?.addChild(self)
        
        titleLabel?.text       = title
        titleLabel?.isHidden   = title == nil
        messageLabel?.text     = message
        messageLabel?.isHidden = message == nil
        
        self.action = action
        
        negativeButton?.isHidden = action == nil
        
        showAnimation()
    }
    
    /// Make animation when alert view show
    private func showAnimation() {
        let bottomFrame = alertView.frame.height
        
        overlayView.alpha = 0
        self.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        UIView.animate(withDuration: 0.24) {
            self.overlayView.alpha = 1
            self.alertView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let updatedY = self.alertView.frame.origin.y + translation.y
        let isCanMove = updatedY > view.frame.height - alertView.frame.height && updatedY < view.frame.height
        let y = alertView.frame.height - (view.frame.height - updatedY)
        if isCanMove {
            alertView.transform = CGAffineTransform(translationX: 0, y: y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: self.view)
            
            if velocity.y > 250 {
                close()
            } else if velocity.y < -250 {
                UIView.animate(withDuration: 0.24) {
                    self.alertView.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            } else {
                let halfH = alertView.frame.height / 2
                let remainH = view.frame.height - alertView.frame.minY
                if halfH > remainH {
                    close()
                } else {
                    UIView.animate(withDuration: 0.24) {
                        self.alertView.transform = CGAffineTransform(translationX: 0, y: 0)
                    }
                }
            }
        }
    }
    
    /// Submit close and call action
    @objc func submitAction() {
        action?()
        close()
    }
    
    /// Close action
    @objc private func action(_ button: UIButton) {
        if button == positiveButton {
            submitAction()
            return;
        }
        close()
    }
    
    /// Make animation when alert view close
    @objc func close() {
        let bottomFrame = alertView.frame.height
        
        self.removeFromParent()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView.alpha = 0
            self.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        }, completion: { (finished) in
            self.view.removeFromSuperview()
        })
    }

}

extension UIViewController {
    func presentAlertSheet(title: String?, message: String?, action: (() -> Void)?) {
        let alert = AlertSheetController()
        alert.show(title: title, message: message, action: action)
    }
}
