//
//  EditPassVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class EditPassVC: ViewController {

    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var oldPassFld: FloaticonField!
    @IBOutlet weak var newPassFld: FloaticonField!
    @IBOutlet weak var retypePassFld: FloaticonField!
    
    var viewModel = ProfileVM()
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        saveBtn.target = self
        saveBtn.action = #selector(savePass)
        
        closeBtn.target = self
        closeBtn.action = #selector(close)
    }
    
    /// Dismiss current view controller
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Save profile update data
    @objc func savePass() {
        let oldPass = oldPassFld.text!
        let newPass = newPassFld.text!
        let retypePass = retypePassFld.text!
        
        LoadIndicatorView.shared.startAnimating()
        viewModel.editPass(oldPass: oldPass, newPass: newPass, retypePass: retypePass, onFinish: { [weak self] (isSuccess, message) in
            LoadIndicatorView.shared.stopAnimating()
            
            self?.presentAlert(title: nil, message: message, action: {
                if isSuccess {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        })
    }

}
