//
//  Item.swift
//  iOStarter
//
//  Created by Macintosh on 05/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation
import SwiftyJSON

class Item: ModelData {
    var detail: String = ""
    var id: Int = 0
    var image: String = ""
    var name: String = ""

    required init(fromJson json: JSON) {
        super.init(fromJson: json)
        detail = json["detail"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
    }
}
