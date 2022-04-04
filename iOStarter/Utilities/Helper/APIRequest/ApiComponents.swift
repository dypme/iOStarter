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
    var method: HTTPMethod
    private var parametersArr: [ApiParameter]
    
    init(path: String, method: HTTPMethod, parameters: [ApiParameter] = []) {
        self.url = URL(string: ApiHelper.shared.BASE_URL + path)!
        self.method = method
        self.parametersArr = parameters
    }
    
    init(url: URL, method: HTTPMethod, parameters: [ApiParameter] = []) {
        self.url = url
        self.method = method
        self.parametersArr = parameters
    }
    
    var parameters: Parameters {
        var params = Parameters()
        parametersArr.forEach { param in
            params.updateValue(param.value, forKey: param.key)
        }
        return params
    }
    
    var uploadParameters: UploadParameters {
        var params = UploadParameters()
        parametersArr.forEach { param in
            params.updateValue(param.value, forKey: param.key, mimeType: param.mimeType)
        }
        return params
    }
}
