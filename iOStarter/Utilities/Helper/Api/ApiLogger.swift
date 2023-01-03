//
//  ApiLogger.swift
//  iOStarter
//
//  Created by MBP2022_1 on 02/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import Alamofire

class ApiLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "com.dypme.starter.networklogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
