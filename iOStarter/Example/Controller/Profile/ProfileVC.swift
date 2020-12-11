//
//  ProfileVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ProfileVC: ViewController {

    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameFld: FloaticonField!
    @IBOutlet weak var emailFld: FloaticonField!
    
    let viewModel = ProfileVM()
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        editBtn.target = self
        editBtn.action = #selector(editProfile)
    }
    
    /// Setup layout view
    override func setupView() {
        super.setupView()
        
        photoView.circle()
        
        viewModel.setPhoto(in: photoView)
        nameFld.text = viewModel.name
        emailFld.text = viewModel.email
    }
    
    /// Present edit profile view controller
    @objc func editProfile() {
        let vc = StoryboardScene.Profile.editProfileVC.instantiate()
        vc.viewModel = viewModel
        self.present(vc, animated: true, completion: nil)
    }

}
