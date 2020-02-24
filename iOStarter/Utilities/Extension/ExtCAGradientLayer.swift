//
//  ExtCAGradientLayer.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case left
    case right
    case top
    case bottom
}

extension CAGradientLayer {
    /// Initailize gradient layer with specific frame, colors for gradient, and direction of gradient
    ///
    /// - Parameters:
    ///   - frame: Layer poisiton and size
    ///   - colors: Gradient layer color
    ///   - direction: Direction gradient layer color
    convenience init(frame: CGRect, colors: [UIColor], direction: Direction) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        switch direction {
        case .top:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .bottom:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        case .left:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        case .right:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        }
    }
    
    /// Set rendering layer into image
    ///
    /// - Returns: UIimage result from rendering
    func gradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
