//
//  ExtUIImage.swift
//  iOStarter
//
//  Created by Crocodic Studio on 31/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum PhotoQuality {
        case lowestJPEG
        case lowJPEG
        case mediumJPEG
        case highJPEG
        case highestJPEG
        case uncompressedPNG
    }
    
    /// Render image with specific background color and size
    ///
    /// - Parameters:
    ///   - color: Color of background image
    ///   - size: Size of image
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// Uncompressed image data
    var uncompressedPNGData: Data?    { return self.pngData()  }
    /// Uncompressed image data without transparent in image
    var highestQualityJPEGData: Data? { return self.jpegData(compressionQuality: 1.0)  }
    /// Compressed image data to 75% of original image without transparent in image
    var highQualityJPEGData: Data?    { return self.jpegData(compressionQuality: 0.75) }
    /// Compressed image data to 50% of original image without transparent in image
    var mediumQualityJPEGData: Data?  { return self.jpegData(compressionQuality: 0.5)  }
    /// Compressed image data to 25% of original image without transparent in image
    var lowQualityJPEGData: Data?     { return self.jpegData(compressionQuality: 0.25) }
    /// Compressed image data to 0% of original image without transparent in image
    var lowestQualityJPEGData:Data?   { return self.jpegData(compressionQuality: 0.0)  }
    
    /// Change size image to new size
    ///
    /// - Parameter newSize: New size will be applied
    /// - Returns: Image with new size
    func resize(to newSize: CGSize = CGSize(width: 350, height: 165)) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Process to convert image to base64string
    ///
    /// - Parameters:
    ///   - image: Image that want to convert
    ///   - quality: Quality of converted image
    /// - Returns: Base64String image
    func base64Image(quality: PhotoQuality) -> String? {
        let data: Data?
        switch quality {
        case .uncompressedPNG:
            data = self.uncompressedPNGData
        case .highestJPEG:
            data = self.highestQualityJPEGData
        case .highJPEG:
            data = self.highQualityJPEGData
        case .mediumJPEG:
            data = self.mediumQualityJPEGData
        case .lowJPEG:
            data = self.lowQualityJPEGData
        case .lowestJPEG:
            data = self.lowestQualityJPEGData
        }
        
        let string = data?.base64EncodedString(options: .lineLength64Characters)
        return string
    }
}
