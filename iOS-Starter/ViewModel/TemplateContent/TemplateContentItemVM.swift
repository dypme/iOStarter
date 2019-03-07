//
//  TemplateContentItemVM.swift
//  iOS-Starter
//
//  Created by Crocodic MBP-2 on 27/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import Kingfisher

class TemplateContentItemVM {
    private var content = TemplateContent()
    
    init() {
        
    }
    
    init(content: TemplateContent) {
        self.content = content
    }
    
    func setPhoto(in view: UIImageView) {
        if let url = URL(string: content.image) {
            view.kf.indicatorType = .activity
            view.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "blank_image"))
        } else {
            view.image = #imageLiteral(resourceName: "blank_image")
        }
    }
    
    var name: String {
        return content.name
    }
    
    var detail: String {
        return content.detail
    }
}
