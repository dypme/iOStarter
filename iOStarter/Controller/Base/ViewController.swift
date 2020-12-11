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
}
