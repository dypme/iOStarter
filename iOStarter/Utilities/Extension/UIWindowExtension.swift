//
//  UIWindowExtension.swift
//  iOStarter
//
//  Created by MBP2022_1 on 17/03/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    func addDevelopmentIndicator() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.layer.zPosition = 1
        
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.alpha = 0.6
        label.text = "In Development"
        label.sizeToFit()
        label.frame.size = label.frame.size.applying(CGAffineTransform(scaleX: 1.2, y: 1.2))
        label.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        let x = self.frame.width - label.frame.width - self.safeAreaInsets.right
        let y = self.safeAreaInsets.top
        label.frame.origin = CGPoint(x: x, y: y)
        
        self.addSubview(label)
    }
}
