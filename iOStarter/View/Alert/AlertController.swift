//
//  AlertController.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import UIKit

class AlertController: ViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    private(set) var overlayView: UIView!
    var shouldResignOnTouchOutside: Bool = true {
        didSet {
            overlayView?.isUserInteractionEnabled = shouldResignOnTouchOutside
        }
    }
    
    let appearance = AlertAppearance()
    
    private(set) var action: (() -> Void)?
    
    private(set) var image: UIImage? = nil
    private(set) var message: String?
    
    init(image: UIImage? = nil, title: String? = nil, message: String? = nil, nibName: String = "AlertView") {
        super.init(nibName: nibName, bundle: nil)
        
        self.image = image
        self.title = title
        self.message = message
        
        transitioningDelegate = self
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        cancelButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        submitButton?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        overlayView = UIView(frame: self.view.frame)
        overlayView.backgroundColor  = .clear
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlayView)
        view.sendSubviewToBack(overlayView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(action(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func setupView() {
        super.setupView()
        
        alertView.layer.cornerRadius = 20
        overlayView.isUserInteractionEnabled = shouldResignOnTouchOutside
        
        cancelButton?.circle()
        submitButton?.circle()
        
        imageView?.image = image
        imageView?.isHidden = image == nil
        
        titleLabel?.text     = title
        titleLabel?.isHidden = title == nil
        messageLabel?.text   = message
        messageLabel?.isHidden = message == nil
        
        setupAppearance()
    }
    
    private func setupAppearance() {
        if appearance.isBlurContainer {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.alertView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            alertView.addSubview(blurEffectView)
            alertView.sendSubviewToBack(blurEffectView)
        }
        
        alertView.backgroundColor = appearance.alertColor
        
        titleLabel?.textColor   = appearance.titleColor
        titleLabel?.font        = appearance.titleFont
        messageLabel?.textColor = appearance.messageColor
        messageLabel?.font      = appearance.messageFont
        
        cancelButton?.setTitleColor(appearance.cancelTextColor, for: UIControl.State())
        cancelButton?.setTitle(appearance.cancelText, for: UIControl.State())
        cancelButton?.isHidden = appearance.isCancelButtonHidden
        cancelButton?.backgroundColor = appearance.cancelColor
        cancelButton?.titleLabel?.font  = appearance.buttonFont
        
        submitButton?.setTitleColor(appearance.submitTextColor, for: UIControl.State())
        submitButton?.setTitle(appearance.submitText, for: UIControl.State())
        submitButton?.isHidden = appearance.isSubmitButtonHidden
        submitButton?.backgroundColor = appearance.submitColor
        submitButton?.titleLabel?.font  = appearance.buttonFont
        
        view.backgroundColor = appearance.overlayColor
    }
    
    /// Show alert in view
    ///
    /// - Parameters:
    ///   - title: title in alert view (optional)
    ///   - message: message in alert view
    ///   - isCancelable: pass true to add cancelable button to dismiss without call oke function
    ///   - action: action when tap ok button (optional)
    func show(action: (() -> Void)? = nil) {
        self.action = action
        let root = UIApplication.shared.activeWindow?.rootViewController
        let presented = root?.presentedControlers.last(where: { ($0 is AlertController) == false })
        let active = presented ?? root
        active?.present(self, animated: true)
    }
    
    /// Submit close and call action
    func submit() {
        self.dismiss(animated: true)
        action?()
    }
    
    /// Close action
    @objc func action(_ sender: AnyObject) {
        if let button = sender as? UIButton, button == submitButton {
            submit()
            return
        }
        self.dismiss(animated: true)
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
}

extension AlertController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertDismissAnimationController()
    }

}

extension NSObject {
    func presentAlert(image: UIImage? = nil, title: String?, message: String?, submitText: String = "OK", action: (() -> Void)? = nil) {
        let alert = AlertController(image: image, title: title, message: message)
        alert.appearance.isCancelButtonHidden = true
        alert.appearance.submitText = submitText
        alert.show(action: action)
    }
    
    func presentConfirmationAlert(image: UIImage? = nil, title: String?, message: String?, submitText: String = AlertAppearance().submitText, action: (() -> Void)? = nil) {
        let alert = AlertController(image: image, title: title, message: message)
        alert.appearance.submitText = submitText
        alert.show(action: action)
    }
}
