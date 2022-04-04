//
//  ExampleVC.swift
//  iOStarter
//
//  Created by Macintosh on 01/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class ExampleVC: ViewController {

    @IBOutlet weak var button: UIButton!
    
    override func setupMethod() {
        super.setupMethod()
        
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        self.presentToast(message: "Hallo World")
    }

}
