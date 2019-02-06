//
//  TemplateContent.swift
//  iOS-Starter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Template of model your content data. Copy this file more recommended than modify this file for your new model
class TemplateContent {
    var id: Int!
    var name: String!
    var detail: String!
    var image: String!
    
    init() {
        id = 0
        name = ""
        detail = ""
        image = ""
    }
    
    init(id: Int, name: String, detail: String, image: String) {
        self.id = id
        self.name = name
        self.detail = detail
        self.image = image
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        detail = json["detail"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
    }
}
