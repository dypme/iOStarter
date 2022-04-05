//
//  LoginVC.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import UIKit

class LoginVC: ViewController {

    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    let viewModel = LoginVM()
    
    override func setupMethod() {
        super.setupMethod()
        
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc func login() {
        let email = emailFld.text!
        let password = passwordFld.text!
        
        if let errorMessage = viewModel.errorMessage(email: email, password: password) {
            self.simpleAlert(title: nil, message: errorMessage, handler: nil)
            return
        }
        viewModel.login(email: email, password: password) { [weak self] isSuccess, message in
            if isSuccess {
                let tabBarVC = self?.presentingViewController as? TabBarMenuVC
                tabBarVC?.setupMenu()
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.simpleAlert(title: nil, message: message, handler: nil)
            }
        }
    }
}
