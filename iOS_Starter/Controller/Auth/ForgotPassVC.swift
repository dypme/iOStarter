//
//  ForgotPassVC.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/5/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class ForgotPassVC: UIViewController {

    // MARK: - Property
    @IBOutlet weak var useridFld: FloaticonField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK: - Data
    let viewModel = ForgotPassVM()
    
    // MARK: - Starting
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        sendBtn.addTarget(self, action: #selector(send), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    /// Set layout view
    func setupView() {
        UITextField.connect(fields: [useridFld])
    }
    
    // MARK: - Action
    /// Starting make forgot password request to server, to get reset password
    @objc func send() {
        view.endEditing(true)
        
        LoadIndicatorView.shared.startAnimating()
        
        let userid = useridFld.text!
        viewModel.forgotPassRequest(userid: userid, onFailed: { [weak self] (text) in
            self?.toastView(message: text)
            
            LoadIndicatorView.shared.stopAnimating()
        }) { [weak self] (text) in
            self?.login()
            
            LoadIndicatorView.shared.stopAnimating()
        }
    }
    
    /// Dismiss current view controller and show login view controller
    @objc func login() {
        self.dismiss(animated: true, completion: nil)
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
