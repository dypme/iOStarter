//
//  ForgotPassVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ForgotPassVC: ViewController {

    // MARK: - Property
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override var fields: [UITextField] {
        return [useridFld]
    }
    
    // MARK: - Data
    let viewModel = AuthVM()
    
    // MARK: - Starting
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        sendBtn.addTarget(self, action: #selector(send), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    // MARK: - Action
    /// Starting make forgot password request to server, to get reset password
    @objc func send() {
        view.endEditing(true)
        
        LoadIndicatorView.shared.startAnimating()
        
        let userid = useridFld.text!
        viewModel.forgotPassRequest(userid: userid, onFinish: { [weak self] (isSuccess, message) in
            LoadIndicatorView.shared.stopAnimating()
            
            self?.toastView(message: message)
            
            if isSuccess {
                self?.login()
            }
        })
    }
    
    /// Dismiss current view controller and show login view controller
    @objc func login() {
        self.dismiss(animated: true, completion: nil)
    }

}
