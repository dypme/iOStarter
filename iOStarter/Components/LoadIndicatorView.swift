//
//  LoadIndicatorView.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class LoadIndicatorView: ViewController {

    static let shared = LoadIndicatorView()
    
    private var activityId: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var topView: UIView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        activityId.color = UIColor.white
    }
    
    init(topView: UIView, tag: Int) {
        self.topView = topView
        
        super.init(nibName: nil, bundle: nil)
        
        view.tag = tag
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        
        activityId.color = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.addSubview(activityId)
        activityId.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityId.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /// Start animation of progress view
    func startAnimating() {
        if let topView = self.topView {
            activityId.stopAnimating()
            activityId.startAnimating()
            
            topView.addSubview(self.view)
            
            view.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        } else {
            guard let window = UIApplication.shared.keyWindow else { return }
            view.bounds = window.bounds
            
            activityId.stopAnimating()
            activityId.startAnimating()
            
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
        let topView = self.superview ?? self
        
        let activityId = LoadIndicatorView(topView: topView, tag: tag)
        if !topView.subviews.contains(where: { $0.tag == tag }) {
            activityId.startAnimating()
        }
    }
    
    /// Stop animating activity indicator in superview of current view
    func stopAnimatingIndicator(tag: Int = 1328) {
        let topView = self.superview ?? self
        if let activityId = topView.subviews.first(where: { $0.tag == tag }) {
            activityId.removeFromSuperview()
        }
    }
}
