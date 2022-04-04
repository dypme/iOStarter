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
        case exampleGet
        case exampleParameter(value: Int)
        case exampleUpload(value: String, data: Data)
        
        var components: ApiComponents {
            switch self {
            case .exampleGet:
                return ApiComponents(path: "/path", method: .get)
                
            case .exampleParameter(let value):
                return ApiComponents(path: "/path/parameter", method: .post, parameters: [
                    ApiParameter(key: "key", value: value)
                ])
                
            case .exampleUpload(let value, let data):
                return ApiComponents(path: "/path/upload", method: .post, parameters: [
                    ApiParameter(key: "key", value: value),
                    ApiParameter(key: "image", value: data, mimeType: .jpg)
                ])
                
            }
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
        // Request timeout is 300 seconds
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
        return afManager?.request(components.url, method: components.method, parameters: components.parameters, headers: headers).responseData(completionHandler: { response in
            apiResponseResult(response: response, callback: callback)
        })
    }
    
    /// Upload data to server
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: All parameters needed when requesting, recomended using only 2 data type (String and Data), Data used for file to upload
    ///   - completion: Callback response from API
    func upload(to path: Path, progress: UploadProgressCallback = nil, callback: ApiResponseCallback) -> DataRequest? {
        let components = path.components
        return afManager?.upload(multipartFormData: { (multipartFormData) in
            for (key, value, mimeType) in components.uploadParameters {
                if let data = value as? Data {
                    if let mimeType = mimeType {
                        multipartFormData.append(data, withName: key, fileName: mimeType.generateFileName, mimeType: mimeType.value)
                    } else {
                        multipartFormData.append(data, withName: key)
                    }
                } else if let array = value as? Array<Any> {
                    array.compactMap({ String(describing: $0).data(using: .utf8) }).forEach { data in
                        multipartFormData.append(data, withName: "\(key)[]")
                    }
                } else if let strData = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(strData, withName: key)
                }
            }
        }, to: components.url, method: components.method, headers: headers)
            .responseData(completionHandler: { response in
                apiResponseResult(response: response, callback: callback)
            })
            .uploadProgress(closure: { progressValue in
                progress?(progressValue.fractionCompleted)
            })
    }
    
    private func apiResponseResult(response: AFDataResponse<Data>, callback: ApiResponseCallback) {
        switch response.result {
        case .success(let value):
            do {
                let json = try JSON(data: value)
                let status = json["status"].intValue
                let message = json["message"].stringValue
                print("API success response:", json)
                callback?(json, status == 1, message)
            } catch {
                print("Error parse JSON:", error.localizedDescription)
                callback?("", false, error.localizedDescription)
            }
        case .failure(let error):
            print("API failure response:", response.debugDescription)
            callback?("", false, error.localizedDescription)
        }
    }
}
