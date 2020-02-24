//
//  ProfileVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameFld: FloaticonField!
    @IBOutlet weak var emailFld: FloaticonField!
    
    let viewModel = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMethod()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        editBtn.target = self
        editBtn.action = #selector(editProfile)
    }
    
    /// Setup layout view
    func setupView() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
