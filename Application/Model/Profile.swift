//
//  Profile.swift
//  Reprime-Core
//
//  Created by Crocodic MBP-2 on 7/7/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation

class Profile: NSObject, NSCoding {
    
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
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let userid = aDecoder.decodeObject(forKey: "userid") as? String ?? ""
        let image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
        let name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        let email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        let password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        
        self.init(id: id, userid: userid, image: image, name: name, email: email, password: password)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(userid, forKey: "userid")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
    }
}
