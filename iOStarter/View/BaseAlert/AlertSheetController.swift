//
//  AlertSheetController.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 10/12/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import UIKit

class AlertSheetController: AlertController {
    
    /// Please use init(image:, title:, message:, actionText:)
    override init(image: UIImage?, title: String?, message: String?, nibName: String = "AlertSheetView") {
        super.init(image: image, title: title, message: message, nibName: nibName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        alertView.addGestureRecognizer(panGesture)
    }
    
    override func setupView() {
        super.setupView()
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 40, width: alertView.frame.width, height: alertView.frame.height + 80))
        bottomView.backgroundColor = appearance.backgroundColor
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        bottomView.frame.size.height += bottomPadding
        alertView.addSubview(bottomView)
        alertView.sendSubviewToBack(bottomView)
    }
    
    /// Make animation when alert view show
    override func showAnimation() {
        let bottomFrame = alertView.frame.height
        let bottomSafeArea = view.safeAreaInsets.bottom
        
        overlayView.alpha = 0
        self.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        UIView.animate(withDuration: 0.24) {
            self.overlayView.alpha = 1
            self.alertView.transform = CGAffineTransform(translationX: 0, y: -bottomSafeArea)
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
    
    /// Make animation when alert view close
    @objc override func close() {
        let bottomFrame = alertView.frame.height
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView.alpha = 0
            self.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        }, completion: { (finished) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }

}

extension UIViewController {
    func presentAlertSheet(image: UIImage?, title: String?, message: String?, shouldResignOnTouchOutside: Bool, with action: (() -> ())?) {
        let alert = AlertSheetController(image: image, title: title, message: message)
        alert.shouldResignOnTouchOutside = shouldResignOnTouchOutside
        alert.show(withAction: action)
    }
}
