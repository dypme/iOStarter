//
//  Profile.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 7/7/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import SwiftyJSON

class Profile: NSObject {
    
    var id: Int
    var userid: String
    var image: String
    var name: String
    var email: String
    var password: String
    
    override init() {
        id = 0
        userid = ""
        image = ""
        name = ""
        email = ""
        password = ""
    }
    
    init(id: Int, userid: String, image: String, name: String, email: String, password: String) {
        self.id = id
        self.userid = userid
        self.image = image
        self.name = name
        self.email = email
        self.password = password
    }
    
    init(fromJSON json: JSON) {
        id = json["id"].intValue
        userid = json["userid"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        email = json["email"].stringValue
        password = json["password"].stringValue
    }
    
    func toJSON() -> JSON {
        var dict = [String : Any]()
        dict.updateValue(id, forKey: "id")
        dict.updateValue(userid, forKey: "userid")
        dict.updateValue(image, forKey: "image")
        dict.updateValue(name, forKey: "name")
        dict.updateValue(email, forKey: "email")
        dict.updateValue(password, forKey: "password")
        return JSON(dict)
    }
}
