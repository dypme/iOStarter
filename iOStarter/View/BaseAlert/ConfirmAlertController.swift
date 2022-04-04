//
//  ConfirmAlertController.swift
//  iOStarter
//
//  Created by Macintosh on 04/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class ConfirmAlertController: AlertController {

    @IBOutlet weak var cancelButton: UIButton!
    
    init(image: UIImage?, title: String, message: String?, actionText: String) {
        super.init(image: image, title: title, message: message, nibName: "ConfirmAlertView")
        
        appearance.actionText = actionText
    }
    
    /// Please use init(image:, title:, message:, actionText:)
    override init(image: UIImage?, title: String?, message: String?, nibName: String = "AlertView") {
        fatalError("Please use init(image:, title:, message:, actionText:)")
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        cancelButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        
        cancelButton?.setTitle(appearance.cancelText, for: UIControl.State())
        cancelButton?.setTitleColor(appearance.cancelTextColor, for: UIControl.State())
        cancelButton?.backgroundColor = appearance.cancelColor
        cancelButton?.titleLabel?.font = appearance.buttonFont
    }
    
    /// init(coder:) has not been implemented
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
