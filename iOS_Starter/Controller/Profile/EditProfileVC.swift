//
//  EditProfileVC.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameFld: FloaticonField!
    @IBOutlet weak var emailFld: FloaticonField!
    @IBOutlet weak var editPassBtn: UIButton!
    
    var viewModel = ProfileVM()
    
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
        saveBtn.target = self
        saveBtn.action = #selector(saveProfile)
        
        closeBtn.target = self
        closeBtn.action = #selector(close)
        
        photoView.setTapGesture(target: self, action: #selector(browsePhoto))
        editPassBtn.addTarget(self, action: #selector(editPass), for: .touchUpInside)
    }
    
    /// Setup layout view
    func setupView() {
        photoView.circle()
        
        viewModel.setPhoto(in: photoView)
        nameFld.text = viewModel.name
        emailFld.text = viewModel.email
    }
    
    /// Dismiss current view controller
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Save profile update data
    @objc func saveProfile() {
        view.endEditing(true)
        
        let name = nameFld.text!
        let email = emailFld.text!
        
        LoadIndicatorView.shared.startAnimating()
        viewModel.editProfile(name: name, email: email, onFailed: { [weak self] (text) in
            LoadIndicatorView.shared.stopAnimating()
            
            self?.toastView(message: text)
        }) { [weak self] (text) in
            LoadIndicatorView.shared.stopAnimating()
            if let nc = self?.presentingViewController as? UINavigationController, let vc = nc.topViewController as? ProfileVC {
                vc.setupView()
            }
            
            self?.cAlertShow(title: nil, message: text, isCancelable: false, action: {
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    /// Update new photo profile
    ///
    /// - Parameter image: new image that want to update
    func savePhotoProfile(image: UIImage?) {
        viewModel.editPhoto(image, onFailed: { [weak self] (message) in
            self?.cAlertShow(message: message)
        }) { [weak self] (message) in
            self?.setupView()
            
            self?.cAlertShow(message: message)
        }
    }
    
    /// Present edit password view controller
    @objc func editPass() {
        let vc = StoryboardScene.Profile.editPassVC.instantiate()
        vc.viewModel = viewModel
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Present action sheet make chaice to select photo
    @objc func browsePhoto() {
        let actionSheet = UIAlertController(title: nil, message: "Take a photo from...", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.takePhoto(from: .camera)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.takePhoto(from: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// Present image picker controller
    ///
    /// - Parameter type: Source type photo get from
    func takePhoto(from type: UIImagePickerController.SourceType) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = type
        imageController.allowsEditing = true
        switch type {
        case .camera:
            imageController.cameraDevice = .front
        default:
            break
        }
        self.present(imageController, animated: true, completion: nil)
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        savePhotoProfile(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
