//
//  ApiParameter.swift
//  iOStarter
//
//  Created by Macintosh on 04/04/22.
//  Copyright © 2022 WahyuAdyP. All rights reserved.
//

import Foundation

class ApiParameter {
    let key: String
    let value: Any
    let mimeType: MimeType?
    
    init(key: String, value: Any, mimeType: MimeType? = nil) {
        self.key = key
        self.value = value
        self.mimeType = mimeType
    }
}
