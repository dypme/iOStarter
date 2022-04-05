//
//  ProfileVC.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class ProfileVC: ViewController {

    @IBOutlet weak var imageView: UIImageView!
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
        
        imageView.kf.setImage(with: viewModel.imageUrl)
        firstNameLbl.text = viewModel.firstName
        lastNameLbl.text = viewModel.lastName
        emailLbl.text = viewModel.email
        genderLbl.text = viewModel.gender
    }
    
    @objc func logout() {
        let confirmAlert = ConfirmAlertSheetController(image: nil, title: "\(L10n.logout)?", message: L10n.Description.confirmLogout, actionText: L10n.logout)
        confirmAlert.appearance.actionTextColor = UIColor.red
        confirmAlert.show { [weak self] in
            self?.viewModel.setLogout()
            self?.tabBarMenuViewController?.setupMenu()
        }
    }

}
