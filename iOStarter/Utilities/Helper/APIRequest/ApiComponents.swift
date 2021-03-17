//
//  ApiComponents.swift
//  iOStarter
//
//  Created by Crocodic-MBP5 on 17/03/21.
//  Copyright © 2021 WahyuAdyP. All rights reserved.
//

import Foundation
import Alamofire

class ApiComponents {
    private(set) var url: URL
    private(set) var method: HTTPMethod
    
    private(set) var parameters = Parameters()
    private(set) var uploadParameters = UploadParameters()
    
    init(path: ApiHelper.Path, method: HTTPMethod) {
        self.url = URL(string: ApiHelper.shared.BASE_URL + path.rawValue)!
        self.method = method
    }
    
    init(url: URL, method: HTTPMethod) {
        self.url = url
        self.method = method
    }
    
    func updateParameter(key: String, value: Any) {
        parameters.updateValue(value, forKey: key)
        uploadParameters.updateValue(value, forKey: key)
    }
    
    func updateParameter(key: String, value: Any, mimeType: MimeType?) {
        uploadParameters.updateValue(value, forKey: key, mimeType: mimeType)
    }
}
