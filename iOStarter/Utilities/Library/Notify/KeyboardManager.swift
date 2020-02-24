//
//  KeyboardStateListener.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 11/6/17.
//  Copyright © 2017 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

/// Setting information about keyboard
class KeyboardManager: NSObject {
    /// Singleton keyboard manager
    static var shared = KeyboardManager()
    /// Boolean value for information keyboard show or hidden
    var isVisible = false
    /// Keyboard frmae
    var keyboardFrame = CGRect.zero
    
    /// Starting keyboard manager
    func start() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// Action when keyboard moving show or hide, getting actual size of keyboard
    @objc func willChangeFrame(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let screenMain = UIScreen.main.bounds
            if (endFrame?.origin.y)! >= screenMain.size.height {
                isVisible = false
            } else {
                isVisible = true
            }
            keyboardFrame = endFrame!
        }
    }
    
    /// Action when keyboard will showing, getting actual size of keyboard
    @objc func willShow(_ notification: Notification) {
        isVisible = true
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            keyboardFrame = endFrame!
        }
    }
    
    /// Action when keyboard will hide, getting actual size of keyboard
    @objc func willHide(_ notification: Notification) {
        isVisible = false
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            keyboardFrame = endFrame!
        }
    } 
}
