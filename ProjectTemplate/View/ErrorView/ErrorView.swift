//
//  ErrorView.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
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
    func setErrorView(frame: CGRect? = nil, image: UIImage? = nil, message: String, tapReload: (() -> Void)?) {
        self.superview?.layoutIfNeeded()
        self.layoutIfNeeded()
        let aFrame = frame ?? self.frame
        ErrorView.shared.show(in: self.superview, frame: aFrame, image: image, message: message, tapReload: tapReload)
    }
}
