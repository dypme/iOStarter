//
//  CAlertView.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class CAlertView: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var okeBtn: UIButton!
    
    static let shared = CAlertView()
    
    init() {
        super.init(nibName: "CAlertView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var action: (() -> Void)?
    func setTapAction(_ action: (() -> Void)?) {
        self.action = action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        dismissBtn.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        okeBtn.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
    }
    
    /// Set layout view
    func setupView() {
        containerView.rounded()
    }
    
    /// Show alert in view
    ///
    /// - Parameters:
    ///   - title: title in alert view (optional)
    ///   - message: message in alert view
    ///   - isCancelable: pass true to add cancelable button to dismiss without call oke function
    ///   - action: action when tap ok button (optional)
    func show(title: String?, message: String, isCancelable: Bool = false, action: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        self.view.frame = window.frame
        window.addSubview(self.view)
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        messageLabel.text = message
        dismissBtn.isHidden = !isCancelable
        self.action = action
        
        showAnimation()
    }
    
    /// Make animation when alert view show
    private func showAnimation() {
        containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// Close action
    @objc func close(_ button: UIButton) {
        if button == okeBtn {
            action?()
        }
        closeAnimation()
    }
    
    /// Make animation when alert view close
    private func closeAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NSObject {
    /// Show custom alert view in every where you want
    ///
    /// - Parameters:
    ///   - title: Title of alert
    ///   - message: Message of alert
    ///   - isCancelable: pass true to add cancelable button to dismiss without call oke function
    ///   - action: Action after show alert
    func cAlertShow(title: String? = nil, message: String, isCancelable: Bool = false, action: (() -> Void)? = nil) {
        CAlertView.shared.show(title: title, message: message, isCancelable: isCancelable, action: action)
    }
}
