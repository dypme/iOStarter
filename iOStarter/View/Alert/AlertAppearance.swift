//
//  AlertAppearance.swift
//  iOStarter
//
//  Created by Macintosh on 07/04/22.
//  
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//  Source: https://github.com/dypme/iOStarter
//

import Foundation
import UIKit

class AlertAppearance {
    var titleColor = UIColor.black
    var titleFont = UIFont.boldSystemFont(ofSize: 17)
    var messageColor = UIColor.black
    var messageFont = UIFont.systemFont(ofSize: 13)
    var cancelText = L10n.Alert.cancelButton
    var cancelTextColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    var cancelColor = UIColor.white
    var isCancelButtonHidden = false
    var submitText = L10n.Alert.actionButton
    var submitTextColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    var submitColor = UIColor.white
    var isSubmitButtonHidden = false
    var buttonFont = UIFont.systemFont(ofSize: 17)
    var alertColor = UIColor.white
    var overlayColor = UIColor.black.withAlphaComponent(0.5)
    var isBlurContainer = false
}
