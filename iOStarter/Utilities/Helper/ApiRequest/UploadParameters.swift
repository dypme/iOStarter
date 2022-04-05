//
//  UploadParameters.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 24/02/20.
//  Copyright © 2020 WahyuAdyP. All rights reserved.
//

import Foundation

struct UploadParameters: Sequence, IteratorProtocol {
    private var parameters = [(key: String, value: Any, mimeType: MimeType?)]()
    
    mutating func updateValue(_ value: Any, forKey key: String) {
        updateValue(value, forKey: key, mimeType: nil)
    }
    
    mutating func updateValue(_ value: Any, forKey key: String, mimeType: MimeType?) {
        if let currentIdxParam = parameters.firstIndex(where: { $0.key == key }) {
            parameters[currentIdxParam].mimeType = mimeType
            parameters[currentIdxParam].value = value
        } else {
            parameters.append((key, value, mimeType))
        }
    }
    
    var index = 0
    
    mutating func next() -> (String, Any, MimeType?)? {
        if index < parameters.count {
            let parameter = parameters[index]
            index += 1
            return (parameter.key, parameter.value, parameter.mimeType)
        } else {
            return nil
        }
    }
}
