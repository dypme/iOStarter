//
//  ApiHelper.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 5/4/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ApiResponseCallback = ((JSON, Bool, String) -> Void)?
typealias UploadProgressCallback = ((Double) -> Void)?

struct ApiHelper {
    static let shared = ApiHelper()
    
    // MARK: - Property
    /// Path API
    enum Path {
        // Add raw string path in comment, help when forgot full path
        /// Path: /path/path
        case example
        case exampleGet
        case exampleParameter(value: Int)
        case exampleSameParameter(value: Int)
        case exampleUpload(value: String, data: Data)
        
        var endpoint: String {
            switch self {
            case .example, .exampleGet: return "/path"
            case .exampleParameter: return "/path/parameter"
            case .exampleSameParameter: return "/path/parameter2"
            case .exampleUpload: return "/path/upload"
            }
        }
        
        var components: ApiComponents {
            // Create default api components with method post
            let components = ApiComponents(path: self, method: .post)
            
            switch self {
            case .exampleGet:
                // Change method to get
                components.method = .get
                
            case .exampleParameter(let value), .exampleSameParameter(let value):
                // Two api with same parameter or method can use same case
                components.updateParameter(key: "key", value: value)
                
            case .exampleUpload(let value, let data):
                // No problem for upload file
                components.updateParameter(key: "key", value: value)
                components.updateParameter(key: "image", value: data, mimeType: .jpg)
                
            default:
                // Yaay, save Your time, other API without parameter, now can ignore create APIComponents
                break
            }
            return components
        }
    }
    
    /// Base API
    let BASE_URL = "BASE_URL"
    
    /// Setting headers
    var headers: HTTPHeaders {
        let data = HTTPHeaders()
        return data
    }
    
    /// Alamofire session manager is Alamfire with some configuration of url session configuration
    private(set) var afManager: Alamofire.Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    // MARK: - Proceess
    /// Make API request to server
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: Parameters used in requesting
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func request(to path: Path, callback: ApiResponseCallback) -> DataRequest? {
        let components = path.components
        return afManager?.request(components.url, method: components.method, parameters: components.parameters, headers: headers).responseJSON { (response) in
            apiResponseResult(response: response, callback: callback)
        }
    }
    
    /// Upload data to server
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: All parameters needed when requesting, recomended using only 2 data type (String and Data), Data used for file to upload
    ///   - completion: Callback response from API
    func upload(to path: Path, progress: UploadProgressCallback = nil, callback: ApiResponseCallback) {
        let components = path.components
        afManager?.upload(multipartFormData: { (multipartFormData) in
            for (key, value, mimeType) in components.uploadParameters {
                if let data = value as? Data, let mimeType = mimeType {
                    multipartFormData.append(data, withName: key, fileName: mimeType.generateFileName, mimeType: mimeType.value)
                } else if let strData = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(strData, withName: key)
                }
            }
        }, to: components.url, method: components.method, headers: headers)
        .responseJSON(completionHandler: { (response) in
            apiResponseResult(response: response, callback: callback)
        })
        .uploadProgress(closure: { (progressValue) in
            progress?(progressValue.fractionCompleted)
        })
    }
    
    private func apiResponseResult(response: AFDataResponse<Any>, callback: ApiResponseCallback) {
        switch response.result {
        case .success(let value):
            print("Get response success:", value)
            
            let json = JSON(value)
            let status = json["status"].intValue
            let message = json["message"].stringValue
            callback?(json, status == 200, message)
        case .failure(let error):
            print("Get full response failed upload:", response.debugDescription)
            
            callback?("", false, error.localizedDescription)
        }
    }
}
