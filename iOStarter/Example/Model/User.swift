//
//  User.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
    var email: String = ""
    var firstName: String = ""
    var gender: String = ""
    var id: Int = 0
    var image: String = ""
    var lastName: String = ""

    init(fromJson json: JSON) {
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        gender = json["gender"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        lastName = json["last_name"].stringValue
    }
    
    func toJson() -> JSON {
        var dict = [String : Any]()
        dict.updateValue(email, forKey: "email")
        dict.updateValue(firstName, forKey: "first_name")
        dict.updateValue(gender, forKey: "gender")
        dict.updateValue(id, forKey: "id")
        dict.updateValue(image, forKey: "image")
        dict.updateValue(lastName, forKey: "last_name")
        return JSON(dict)
    }
}
