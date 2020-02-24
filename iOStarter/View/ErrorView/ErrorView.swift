//
//  ErrorView.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ErrorView: UIViewController {
    
    static let shared = ErrorView()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    private var tapReload: (() -> Void)?
    
    init() {
        super.init(nibName: "ErrorView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        refreshBtn.addTarget(self, action: #selector(reload(_:)), for: .touchUpInside)
    }
    
    /// Show error view in view
    ///
    /// - Parameters:
    ///   - aView: View that will add error view
    ///   - frame: Size & position of error view
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - tapReload: Action to reload fetch data while error occur
    func show(in aView: UIView?, frame: CGRect?, image: UIImage?, message: String, tapReload: (() -> Void)?) {
        guard let aView = aView else { return }
        view.frame = frame == nil ? aView.frame : frame!
        aView.addSubview(view)
        
        imageView.image = image
        imageView.isHidden = image == nil
        
        messageLbl.text = message
        refreshBtn.isHidden = tapReload == nil
        
        self.tapReload = tapReload
        
        refreshBtn.circle()
    }
    
    /// Reload button function action
    ///
    /// - Parameter button: Sender button
    @objc func reload(_ button: UIButton) {
        removeView()
        tapReload?()
    }
    
    /// Remove error view from view
    func removeView() {
        view.removeFromSuperview()
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

extension UIView {
    /// Show error view in front view
    ///
    /// - Parameters:
    ///   - frame: Size & position of error view
    ///   - image: image for error view
    ///   - message: Text to inform user what error happen
    ///   - tapReload: Action to reload fetch data while error occur
    ///   - tag: Mark of error view in superview
    func setErrorView(frame: CGRect? = nil, image: UIImage? = nil, message: String, tapReload: (() -> Void)?, tag: Int = 1431) {
        let controller = self.viewContainingController()
        let controllerView = controller?.view
        
        let errorView = ErrorView()
        errorView.view.tag = tag
        
        if self == controllerView {
            if !self.subviews.contains(where: { $0.tag == tag }) {
                errorView.show(in: self, frame: frame, image: image, message: message, tapReload: tapReload)
            }
        } else {
            if let superview = self.superview, !superview.subviews.contains(where: { $0.tag == tag }) {
                errorView.show(in: self.superview, frame: frame, image: image, message: message, tapReload: tapReload)
            }
        }
    }
    
    /// Stop animating activity indicator in superview of current view
    /// - Parameter tag: Mark of error view in superview
    func removeErrorView(tag: Int = 1431) {
        let controller = self.viewContainingController()
        let controllerView = controller?.view
        
        if self == controllerView {
            if let errorView = self.subviews.filter({ $0.tag == tag}).first {
                errorView.removeFromSuperview()
            }
        } else {
            if let errorView = self.superview?.subviews.filter({ $0.tag == tag}).first {
                errorView.removeFromSuperview()
            }
        }
    }
}
