//
//  CAlertView.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 7/21/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class CAlertView: BaseAlertController {

    override init() {
        super.init(nibName: "CAlertView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
