//
//  ApiPath.swift
//  iOStarter
//
//  Created by Macintosh on 26/04/22.
//  Copyright © 2022 dypme. All rights reserved.
//

import Foundation
import Alamofire

extension ApiComponents {
    static let exampleGet = ApiComponents(path: "/path", method: .get)
    
    static func exampleParameter(value: Int) -> ApiComponents {
        .init(path: "/path/parameter", method: .post, parameters: [
            .init(key: "key", value: value)
        ])
    }
    
    static func exampleUpload(value: String, data: Data) -> ApiComponents {
        .init(path: "/path/upload", method: .post, parameters: [
            .init(key: "key", value: value),
            .init(key: "image", value: data, mimeType: .jpg)
        ])
    }
}
