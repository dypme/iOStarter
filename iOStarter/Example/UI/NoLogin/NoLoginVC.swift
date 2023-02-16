//
//  NoLoginVC.swift
//  iOStarter
//
//  Created by MBP2022_1 on 15/02/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import UIKit

class NoLoginVC: ViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func setupView() {
        super.setupView()
        
        navigationItem.title = L10n.Title.notLogin
    }
    
    override func setupMethod() {
        super.setupMethod()
        
        loginBtn.addTarget(self, action: #selector(openLogin), for: .touchUpInside)
    }
    
    @objc func openLogin() {
        let vc = LoginVC()
        present(vc, animated: true)
    }

}
