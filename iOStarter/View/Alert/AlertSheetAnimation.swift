//
//  AlertSheetAnimation.swift
//  iOStarter
//
//  Created by MBP2022_1 on 03/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import UIKit

class AlertSheetPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.24
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertSheetController = transitionContext.viewController(forKey: .to) as? AlertSheetController else { return }
        
        let containerView = transitionContext.containerView
        let view = alertSheetController.view!
        view.frame = containerView.frame
        containerView.addSubview(view)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let bottomFrame = alertSheetController.alertView.frame.height
        alertSheetController.overlayView.alpha = 0
        alertSheetController.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        UIView.animate(withDuration: animationDuration, animations: {
            alertSheetController.overlayView.alpha = 1
            alertSheetController.alertView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class AlertSheetDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertSheetController = transitionContext.viewController(forKey: .from) as? AlertSheetController else { return }
        
        let containerView = transitionContext.containerView
        let view = alertSheetController.view!
        view.frame = containerView.frame
        containerView.addSubview(view)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let bottomFrame = alertSheetController.alertView.frame.height
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            alertSheetController.overlayView.alpha = 0
            alertSheetController.alertView.transform = CGAffineTransform(translationX: 0, y: bottomFrame)
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

