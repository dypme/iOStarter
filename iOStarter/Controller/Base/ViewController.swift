//
//  ViewController.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/12/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var fields: [UITextField] {
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backBtn = self.navigationItem.leftBarButtonItem {
            if backBtn.tag == 0 {
                backBtn.target = self
                backBtn.action = #selector(popBackNavigation(_:))
            }
        }
        
        setupMethod()
        setupView()
        
        fetch()
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        UITextField.connect(fields: fields)
    }
    
    func setupView() {
    }
    
    @objc func fetch() {
        
    }
    
    /// Function back to presenting viewcontroller
    ///
    /// - Parameter barButtonItem: Sender of button bar item
    @objc private func popBackNavigation(_ barButtonItem: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
