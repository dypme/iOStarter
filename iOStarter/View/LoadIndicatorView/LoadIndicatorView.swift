//
//  LoadIndicatorView.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class LoadIndicatorView: UIViewController {

    static let shared = LoadIndicatorView()
    
    @IBOutlet weak var activityId: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: "LoadIndicatorView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityId.startAnimating()
    }
    
    /// Start animation of progress view
    func startAnimating() {
        if let window = UIApplication.shared.keyWindow {
            self.view.isUserInteractionEnabled = true
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            self.view.frame = window.frame
            
            self.activityId.color = UIColor.white
            self.activityId.stopAnimating()
            self.activityId.startAnimating()
            
            window.addSubview(self.view)
        }
    }
    
    /// Stop animation of progress view
    func stopAnimating() {
        self.view.removeFromSuperview()
    }

}

extension UIView {
    /// Start animating activity indicator in superview of current view
    func startAnimatingIndicator(tag: Int = 1328) {
        let controller = self.viewContainingController()
        let controllerView = controller?.view
        
        let activityId = LoadIndicatorView()
        activityId.view.tag = tag
        activityId.view.isUserInteractionEnabled = false
        activityId.view.backgroundColor = UIColor.clear
        activityId.view.frame = CGRect(origin: .zero, size: self.frame.size)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        activityId.view.frame = self.frame
        
        if self == controllerView {
            if !self.subviews.contains(where: { $0.tag == tag }) {
                self.addSubview(activityId.view)
            }
        } else {
            if let superview = self.superview, !superview.subviews.contains(where: { $0.tag == tag }) {
                self.superview?.addSubview(activityId.view)
            }
        }
    }
    
    /// Stop animating activity indicator in superview of current view
    func stopAnimatingIndicator(tag: Int = 1328) {
        let controller = self.viewContainingController()
        let controllerView = controller?.view
        
        if self == controllerView {
            if let activityId = self.subviews.filter({ $0.tag == tag}).first {
                activityId.removeFromSuperview()
            }
        } else {
            if let activityId = self.superview?.subviews.filter({ $0.tag == tag}).first {
                activityId.removeFromSuperview()
            }
        }
    }
}
