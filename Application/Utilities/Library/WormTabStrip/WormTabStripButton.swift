//
//  TestTabButton.swift
//  EYViewPager
//
//  Created by Ezimet Yusuf on 10/16/16.
//  Copyright © 2016 ww.otkur.biz. All rights reserved.
//

import Foundation
import UIKit

/// Wormtabstripbutton for top view
class WormTabStripButton: UILabel {
    /// Position of current button
    var index: Int?
    /// Padding for text in button
    var paddingToEachSide: CGFloat = 10
    /// Text use in button
    var tabText: NSString? {
        didSet{
            let textSize:CGSize = tabText!.size(withAttributes: [NSAttributedString.Key.font: font!])
            self.frame.size.width = textSize.width + paddingToEachSide * 2
            
            self.text = String(tabText!)
        }
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience required init(key:String) {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
