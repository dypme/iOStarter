//
//  RegisterVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class RegisterVC: ViewController {

    // MARK: - Property
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var passwordFld: FloaticonField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override var fields: [UITextField] {
        return [useridFld, passwordFld]
    }
    
    // MARK: - Data
    let viewModel = AuthVM()
    
    // MARK: - Starting
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    // MARK: - Action
    /// Dismiss current view controller and show login view controller
    @objc func login() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Starting make register request to server
    @objc func register() {
        view.endEditing(true)
        
        LoadIndicatorView.shared.startAnimating()
        
        let userid = useridFld.text!
        let password = passwordFld.text!
        
        viewModel.registerRequest(userid: userid, password: password, onFinish: { [weak self] (isSuccess, message) in
            LoadIndicatorView.shared.stopAnimating()
            
            if isSuccess {
                self?.presentAlert(title: nil, message: message, action: {
                    self?.login()
                })
            } else {
                self?.toastView(message: message)
            }
        })
    }
}
