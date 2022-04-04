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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private(set) var overlayView: UIView!
    var shouldResignOnTouchOutside: Bool = true {
        didSet {
            overlayView?.isUserInteractionEnabled = shouldResignOnTouchOutside
            alertView?.gestureRecognizers?.forEach({ (gesture) in
                gesture.isEnabled = shouldResignOnTouchOutside
            })
        }
    }
    
    var appearance = AlertAppearance()
    
    private var tapAction: (() -> ())?
    
    private var parentController: UIViewController?
    func setParentController(_ controller: UIViewController) {
        parentController = controller
    }
    
    private var image: UIImage?
    private var message: String?
    
    init(image: UIImage?, title: String?, message: String?, nibName: String = "AlertView") {
        super.init(nibName: nibName, bundle: nil)
        
        self.image = image
        self.title = title
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        actionButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        overlayView = UIView(frame: self.view.frame)
        overlayView.backgroundColor  = .clear
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlayView)
        view.sendSubviewToBack(overlayView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        overlayView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupAppearance() {
        alertView.layer.cornerRadius = 15
        alertView.backgroundColor = appearance.backgroundColor
        
        titleLabel?.textColor   = appearance.titleColor
        titleLabel?.font        = appearance.titleFont
        messageLabel?.textColor = appearance.messageColor
        messageLabel?.font      = appearance.messageFont
        
        actionButton.setTitle(appearance.actionText, for: UIControl.State())
        actionButton.setTitleColor(appearance.actionTextColor, for: UIControl.State())
        actionButton.backgroundColor = appearance.actionColor
        actionButton.titleLabel?.font = appearance.buttonFont
        
        overlayView.backgroundColor          = appearance.overlayColor
        overlayView.isUserInteractionEnabled = shouldResignOnTouchOutside
        
        alertView.gestureRecognizers?.forEach({ (gesture) in
            gesture.isEnabled = shouldResignOnTouchOutside
        })
        
        view.backgroundColor = .clear
    }
    
    override func setupView() {
        super.setupView()
        
        imageView?.image = image
        imageView?.isHidden = image == nil
        titleLabel?.text       = title
        titleLabel?.isHidden   = title == nil
        messageLabel?.text     = message
        messageLabel?.isHidden = message == nil
        
        alertView.clipsToBounds      = true
        
        if appearance.isBlurContainer {
            let blurEffect                  = UIBlurEffect(style: .light)
            let blurEffectView              = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame            = self.alertView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            alertView.addSubview(blurEffectView)
            alertView.sendSubviewToBack(blurEffectView)
        }
        
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
    func show(with action: (() -> ())? = nil) {
        self.tapAction = action
        
        guard let window = UIApplication.shared.keyWindow else { return }
        self.view.frame  = window.frame
        window.addSubview(self.view)
        
        if parentController == nil {
            parentController = UIApplication.shared.currentActiveController()
        }
        if let alerts = parentController?.children.compactMap({ $0 as? AlertController }) {
            alerts.forEach { (controller) in
                controller.close()
            }
        }
        parentController?.addChild(self)
        parentController?.view.endEditing(true)
        
        showAnimation()
    }
    
    /// Make animation when alert view show
    func showAnimation() {
        alertView.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
        view.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// Close action
    @objc private func action(_ button: UIButton) {
        tapAction?()
        close()
    }
    
    /// Make animation when alert view close
    @objc func close() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func presentAlert(image: UIImage?, title: String?, message: String?, shouldResignOnTouchOutside: Bool, with action: (() -> ())?) {
        let alert = AlertSheetController(image: image, title: title, message: message)
        alert.shouldResignOnTouchOutside = shouldResignOnTouchOutside
        alert.show(with: action)
    }
}
