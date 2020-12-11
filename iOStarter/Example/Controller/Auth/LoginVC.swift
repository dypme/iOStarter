//
//  LoginVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class LoginVC: ViewController {
    
    // MARK: Property
    
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var passwordFld: FloaticonField!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!

    override var fields: [UITextField] {
        return [useridFld, passwordFld]
    }
    
    // MARK: - Data
    let viewModel = AuthVM()
    
    // MARK: - Starting
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        forgotPassBtn.addTarget(self, action: #selector(forgotPass), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    // MARK: - Action
    /// Present forgot password controller modally
    @objc func forgotPass() {
        let vc = StoryboardScene.Auth.forgotPassVC.instantiate()
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Present register controller modally
    @objc func register() {
        let vc = StoryboardScene.Auth.registerVC.instantiate()
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Starting make login request to server
    @objc func login() {
        view.endEditing(true)
        
        let userid = useridFld.text!
        let password = passwordFld.text!
        
        LoadIndicatorView.shared.startAnimating()
        viewModel.loginRequest(userid: userid, password: password, onFinish: { [weak self] (isSuccess, message) in
            LoadIndicatorView.shared.stopAnimating()
            
            if isSuccess {
                AppDelegate.shared.refreshMainController()
                guard let main = AppDelegate.shared.mainVC else { return }
                main.modalPresentationStyle = .fullScreen
                self?.present(main, animated: true, completion: {
                    self?.useridFld.text = ""
                    self?.passwordFld.text = ""
                })
            } else {
                self?.toastView(message: message)
            }
        })
    }

}
