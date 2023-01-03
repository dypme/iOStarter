//
//  ApiResponse.swift
//  iOStarter
//
//  Created by MBP2022_1 on 02/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiResponse {
    let isSuccess: Bool
    let message: String
    let json: JSON
    
    init(dataTask: DataTask<Data>) async {
        do {
            let value = try await dataTask.value
            json = try JSON(data: value)
            isSuccess = json["status"].intValue == 1
            message = json["message"].stringValue
        } catch {
            json = JSON()
            isSuccess = false
            message = error.localizedDescription
        }
    }
}

