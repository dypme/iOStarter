//
//  LoginVC.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: Property
    
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var passwordFld: FloaticonField!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!

    // MARK: - Data
    let viewModel = LoginVM()
    
    // MARK: - Starting
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
        
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        forgotPassBtn.addTarget(self, action: #selector(forgotPass), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    /// Set layout view
    func setupView() {
        UITextField.connect(fields: [useridFld, passwordFld])
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
        
        LoadIndicatorView.shared.startAnimating()
        
        let userid = useridFld.text!
        let password = passwordFld.text!

        viewModel.loginRequest(userid: userid, password: password, onFailed: { [weak self] (text) in
            self?.toastView(message: text)

            LoadIndicatorView.shared.stopAnimating()
        }) { [weak self] (text) in
            LoadIndicatorView.shared.stopAnimating()

            guard let main = AppDelegate.shared.mainVC else { return }
            if AppDelegate.shared.window?.rootViewController == main {
                self?.dismiss(animated: true, completion: nil)
            } else {
                main.modalPresentationStyle = .fullScreen
                self?.present(main, animated: true, completion: {
                    self?.useridFld.text = ""
                    self?.passwordFld.text = ""
                })
            }
        }
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
