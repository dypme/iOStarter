//
//  AlertAnimation.swift
//  iOStarter
//
//  Created by MBP2022_1 on 03/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import UIKit

class AlertPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.24
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .to) as? AlertController else { return }
        
        let containerView = transitionContext.containerView
        let view = alertController.view!
        view.frame = containerView.frame
        containerView.addSubview(view)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        alertController.alertView.transform = CGAffineTransform(scaleX: 1.23, y: 1.23)
        view.alpha = 0
        UIView.animate(withDuration: animationDuration, animations: {
            alertController.view.alpha = 1
            alertController.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class AlertDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .from) as? AlertController else { return }
        
        let containerView = transitionContext.containerView
        let view = alertController.view!
        view.frame = containerView.frame
        containerView.addSubview(view)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, animations: {
            alertController.view.alpha = 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
