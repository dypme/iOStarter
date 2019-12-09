// 
//  ExampleDetailVC.swift
//  iOS_Starter
//
//  Created by Crocodic Studio on 09/12/19.
//  Copyright © 2019 Crocodic Studio. All rights reserved.
//

import UIKit

class ExampleDetailVC: ViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailbl: UILabel!
    
    var viewModel: ExampleItemVM!
    
    /// Array of fields on this viewcontroller
    override var fields: [UITextField] {
        return []
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
    }
    
    /// Setup layout view
    override func setupView() {
        super.setupView()
        
        photoView.kf.setImage(with: viewModel.photo)
        nameLbl.text = viewModel.name
        detailbl.text = viewModel.detail
    }
        
    /// Get data content
    @objc override func fetch() {
        
    }
}
