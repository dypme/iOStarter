//
//  LoginVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 14/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

class LoginVC: ViewController {

    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    let viewModel = LoginVM()
    
    override func setupMethod() {
        super.setupMethod()
        
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc func login() {
        let email = emailFld.text!
        let password = passwordFld.text!
        if let errorMessage = viewModel.errorMessage(email: email, password: password) {
            self.presentAlert(title: nil, message: errorMessage)
            return
        }
        viewModel.login(email: email, password: password)
        close()
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
}
