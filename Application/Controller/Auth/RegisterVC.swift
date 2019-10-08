//
//  RegisterVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    // MARK: - Property
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var passwordFld: FloaticonField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Data
    let viewModel = RegisterVM()
    
    // MARK: - Starting
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    /// Set layout view
    func setupView() {
        UITextField.connect(fields: [useridFld, passwordFld])
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
        
        viewModel.registerRequest(userid: userid, password: password, onFailed: { [weak self] (text) in
            LoadIndicatorView.shared.stopAnimating()
            
            self?.toastView(message: text)
        }) { [weak self] (text) in
            LoadIndicatorView.shared.stopAnimating()
            
            self?.baseAlertShow(title: nil, message: text, action: {
                self?.login()
            })
            
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
