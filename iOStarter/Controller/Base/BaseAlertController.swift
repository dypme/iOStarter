//
//  BasePopAlertController.swift
//  iOStarter
//
//  Created by Crocodic Studio on 17/06/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class BaseAlertController: UIViewController {

    class PopupAppearance {
        var titleColor: UIColor      = UIColor.black
        var titleFont: UIFont        = UIFont.boldSystemFont(ofSize: 17)
        var messageColor: UIColor    = UIColor.black
        var messageFont: UIFont      = UIFont.systemFont(ofSize: 13)
        var dismissText: String      = "Cancel"
        var dismissColor: UIColor    = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        var okeText: String          = "Submit"
        var okeColor: UIColor        = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        var buttonFont: UIFont       = UIFont.systemFont(ofSize: 17)
        var backgroundColor: UIColor = UIColor.white
        var overlayColor: UIColor    = UIColor.black.withAlphaComponent(0.4)
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var okeBtn: UIButton!
    
    static let appearance = PopupAppearance()
    
    let appearance = BaseAlertController.appearance
    
    private var action: (() -> Void)?
    func setTapAction(_ action: (() -> Void)?) {
        self.action = action
    }
    
    init() {
        super.init(nibName: "BasePopUpView", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseMethod()
        setBaseView()
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    private func setBaseMethod() {
        dismissBtn?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        okeBtn?.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeAnimation))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        setupMethod()
    }
    
    func setupMethod() {
        
    }
    
    /// Set layout view
    private func setBaseView() {
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds      = true
        
        let blurEffect                  = UIBlurEffect(style: .light)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = self.containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(blurEffectView)
        containerView.sendSubviewToBack(blurEffectView)
        
        setupAppearance()
        setupView()
    }
    
    private func setupAppearance() {
        containerView.backgroundColor = appearance.backgroundColor
        
        titleLabel?.textColor   = appearance.titleColor
        titleLabel?.font        = appearance.titleFont
        messageLabel?.textColor = appearance.messageColor
        messageLabel?.font      = appearance.messageFont
        
        dismissBtn?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        dismissBtn?.layer.borderWidth = 0.6
        dismissBtn?.setTitleColor(appearance.dismissColor, for: UIControl.State())
        dismissBtn?.setTitle(appearance.dismissText, for: UIControl.State())
        dismissBtn?.titleLabel?.font  = appearance.buttonFont
        okeBtn?.layer.borderColor     = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        okeBtn?.layer.borderWidth     = 0.6
        okeBtn?.setTitleColor(appearance.okeColor, for: UIControl.State())
        okeBtn?.setTitle(appearance.okeText, for: UIControl.State())
        okeBtn?.titleLabel?.font      = appearance.buttonFont
        
        view.backgroundColor = appearance.overlayColor
    }
    
    func setupView() {
        
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
        
        setTapAction(action)
        
        showAnimation()
    }
    
    /// Make animation when alert view show
    private func showAnimation() {
        containerView.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
        view.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// Submit close and call action
    func submitAction() {
        action?()
        closeAnimation()
    }
    
    /// Close action
    @objc private func action(_ button: UIButton) {
        if button == okeBtn {
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

extension BaseAlertController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView == containerView || containerView.subviews.contains(touchView) {
                return false
            }
        }
        return true
    }
}

extension UIViewController {
    func baseAlertShow(title: String?, message: String?, action: (() -> Void)?) {
        let alert = BaseAlertController()
        alert.show(title: title, message: message, action: action)
    }
}
