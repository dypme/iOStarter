//
//  LaunchScreenVC.swift
//  iOStarter
//
//  Created by Macintosh on 01/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import UIKit

class LaunchScreenVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLaunchScreen()
    }
    
    func startLaunchScreen() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            guard let vc = AppDelegate.shared.mainController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}
