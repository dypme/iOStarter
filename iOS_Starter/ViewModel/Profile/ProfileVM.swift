//
//  ProfileVM.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 28/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import Kingfisher

class ProfileVM {
    private var profile = Profile()
    
    init() {
        guard let profile = UserSession.shared.profile else { return }
        self.profile = profile
    }
    
    /// Id of user profile
    var id: Int {
        return profile.id
    }
    
    /// User id/ unique id of user profile
    var userid: String {
        return profile.userid
    }
    
    /// Set user profile photo
    ///
    /// - Parameter view: imageview that will present user photo
    func setPhoto(in view: UIImageView) {
        if let url = URL(string: profile.image) {
            view.kf.indicatorType = .activity
            view.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "blank_image"))
        } else {
            view.image = #imageLiteral(resourceName: "blank_image")
        }
    }
    
    /// Name of user profile
    var name: String {
        return profile.name
    }
    
    /// Email of user profile
    var email: String {
        return profile.email
    }
    
    /// Password of user profile
    var password: String {
        return profile.password
    }
    
    /// Edit photo profile request to server
    ///
    /// - Parameters:
    ///   - data: Data image that will upload
    ///   - error: Error response request
    ///   - success: Response success update photo profile
    func editPhoto(_ image: UIImage?, onFailed: ((String) -> Void)?, onSuccess: ((String) -> Void)?) {
        guard let image = image else {
            onFailed?("Image not found")
            return
        }
        // Example convert image to data
        let data = Config.shared.setImageData(image, quality: .lowestJPEG)
        // Example convert image to base64
        let base64Data = Config.shared.setBase64Image(image, quality: .lowestJPEG)
        
        self.profile.image = "blank_image"
        UserSession.shared.setProfile(self.profile)
        
        onSuccess?("Success")
        
//        ApiHelper.shared.exampleUpload(value: "Image", photo: data) { (json, isSuccess, message) in
//            if isSuccess {
//                // Example new image response, Change to your response new image
//                let image = json["image"].stringValue
//
//                self.profile.image = image
//                UserSession.shared.setProfile(self.profile)
//
//                onSuccess?(message)
//            } else {
//                onFailed?(message)
//            }
//        }
    }
    
    func editProfile(name: String, email: String, onFailed: ((String) -> Void)?, onSuccess: ((String) -> Void)?) {
        if name.isEmpty || email.isEmpty {
            onFailed?("Please complete data")
            return
        }
        
        if !email.isValidEmail {
            onFailed?("Please use valid email")
            return
        }
        
        profile.name = name
        profile.email = email
        
        UserSession.shared.setProfile(profile)
        
        onSuccess?("Success")
        
//        ApiHelper.shared.example(value: name) { (json, isSuccess, message) in
//            if isSuccess {
//                self.profile.name = name
//                self.profile.email = email
//
//                UserSession.shared.setProfile(self.profile)
//
//                onSuccess?(message)
//            } else {
//                onFailed?(message)
//            }
//        }
    }
    
    func editPass(oldPass: String, newPass: String, retypePass: String, onFailed: ((String) -> Void)?, onSuccess: ((String) -> Void)?) {
        if oldPass.isEmpty || newPass.isEmpty || retypePass.isEmpty {
            onFailed?("Please complete data")
            return
        }
        if oldPass.count < 6 || newPass.count < 6 || retypePass.count < 6 {
            onFailed?("Password minimal 6 charcters")
            return
        }
        if oldPass != profile.password {
            onFailed?("Old password not match")
            return
        }
        if newPass == oldPass {
            onFailed?("Please use difference new password")
            return
        }
        if newPass != retypePass {
            onFailed?("Please retype new password correctly")
            return
        }
        
        profile.password = newPass
        
        UserSession.shared.setProfile(profile)
        
        onSuccess?("Success")
        
//        ApiHelper.shared.example(value: name) { (json, isSuccess, message) in
//            if isSuccess {
//                self.profile.name = name
//                self.profile.email = email
//
//                UserSession.shared.setProfile(self.profile)
//
//                onSuccess?(message)
//            } else {
//                onFailed?(message)
//            }
//        }
    }
    
}
