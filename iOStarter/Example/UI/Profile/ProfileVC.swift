//
//  ProfileVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 15/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

class ProfileVC: ViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    let viewModel = ProfileVM()
    
    override func setupMethod() {
        super.setupMethod()
        
        logoutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    override func setupView() {
        super.setupView()
        
        photoView.kf.setImage(with: viewModel.imageUrl)
        firstNameLbl.text = viewModel.firstName
        lastNameLbl.text = viewModel.lastName
        emailLbl.text = viewModel.email
        genderLbl.text = viewModel.gender
    }
    
    @objc func logout() {
        viewModel.setLogout()
    }
    
}
