//
//  ViewController.swift
//  ProjectTemplate
//
//  Created by Crocodic MBP-2 on 7/12/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMethod()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        let pickerField = PickerField(textField: field)
        pickerField.appearance.isHiddenBlocker = true
        pickerField.setDatePicker()
    }

}

/// Add this extension if your view need gesture to swipe drawer menu
extension ViewController: JVFloatingDrawerCenterViewController {
    func shouldOpenDrawer(with drawerSide: JVFloatingDrawerSide) -> Bool {
        return true
    }
}
