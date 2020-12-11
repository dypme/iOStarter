//
//  EditProfileVC.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import UIKit

class EditProfileVC: ViewController {

    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameFld: FloaticonField!
    @IBOutlet weak var emailFld: FloaticonField!
    @IBOutlet weak var editPassBtn: UIButton!
    
    var viewModel: ProfileVM!
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    override func setupMethod() {
        super.setupMethod()
        
        saveBtn.target = self
        saveBtn.action = #selector(saveProfile)
        
        closeBtn.target = self
        closeBtn.action = #selector(close)
        
        photoView.setTapGesture(target: self, action: #selector(browsePhoto))
        editPassBtn.addTarget(self, action: #selector(editPass), for: .touchUpInside)
    }
    
    /// Setup layout view
    override func setupView() {
        super.setupView()
        
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
        viewModel.editProfile(name: name, email: email, onFinish: { [weak self] (isSuccess, message) in
            LoadIndicatorView.shared.stopAnimating()
            
            if isSuccess {
                if let nc = self?.presentingViewController as? UINavigationController, let vc = nc.topViewController as? ProfileVC {
                    vc.setupView()
                }
                self?.presentAlert(title: nil, message: "Apakah Anda yakin ingin keluar?", action: { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                })
            } else {
                self?.toastView(message: message)
            }
        })
    }
    
    /// Update new photo profile
    ///
    /// - Parameter image: new image that want to update
    func savePhotoProfile(image: UIImage?) {
        viewModel.editPhoto(image, onFinish: { [weak self] (isSuccess, message) in
            self?.setupView()
            self?.presentAlert(title: nil, message: message, action: nil)
        })
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
            let camera = CameraController(camera: .back, isFullscreenCamera: true, isAllowSwitchCamera: true, isAllowFlashlight: true)
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
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
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        savePhotoProfile(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC: CameraControllerDelegate {
    func didCapture(_ picker: CameraController, image: UIImage, description: String) {
        picker.dismiss(animated: true, completion: nil)
        
        photoView.image = image
    }
}
