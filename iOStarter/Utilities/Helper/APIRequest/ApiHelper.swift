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

struct ApiHelper {
    static let shared = ApiHelper()
    
    // MARK: - Property
    /// Path API
    enum Path: String {
        // Add raw string path in comment, help when forgot full path
        /// Path: /path/path
        case path = "/path/path"
    }
    
    /// Base API
    let BASE_URL = "BASE_URL"
    
    /// Setting headers
    var headers: HTTPHeaders {
        let data = HTTPHeaders()
        return data
    }
    
    /// Alamofire session manager is Alamfire with some configuration of url session configuration
    private(set) var afManager: Session? = {
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
    private func apiRequest(components: ApiComponents, callback: ApiResponseCallback) -> DataRequest? {
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
    private func uploadRequest(components: ApiComponents, callback: ApiResponseCallback) {
        afManager?.upload(multipartFormData: { (multipartFormData) in
            for (key, value, mimeType) in components.uploadParameters {
                if let data = value as? Data, let mimeType = mimeType {
                    multipartFormData.append(data, withName: key, fileName: mimeType.generateFileName, mimeType: mimeType.value)
                } else if let strData = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(strData, withName: key)
                }
            }
        }, to: components.url, method: components.method, headers: headers).responseJSON(completionHandler: { (response) in
            apiResponseResult(response: response, callback: callback)
        })
    }
    
    private func apiResponseResult(response: AFDataResponse<Any>, callback: ApiResponseCallback) {
        switch response.result {
        case .success(let value):
            print("Get response success:", value)
            
            let json = JSON(value)
            let status = json["api_status"].intValue
            let message = json["api_message"].stringValue
            callback?(json, status == 1, message)
        case .failure(let error):
            print("Get full response failed upload:", response.debugDescription)
            
            callback?("", false, error.localizedDescription)
        }
    }
    
    // MARK: - Example
    /// Template: Example function to request API
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func example(value: String, callback: ApiResponseCallback) -> DataRequest? {
        let components = ApiComponents(path: .path, method: .post)
        
        return apiRequest(components: components, callback: callback)
    }
    
    /// Template: Example function to request API with response as list
    ///
    /// - Parameters:
    ///   - searchText: Search text to find specific name
    ///   - limit: Limit response array every page
    ///   - offset: Number of page in list
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func exampleList(searchText: String, limit: Int, offset: Int, callback: ApiResponseCallback) -> DataRequest? {
        let components = ApiComponents(path: .path, method: .get)
        components.updateParameter(key: "search", value: searchText)
        components.updateParameter(key: "offset", value: offset)
        components.updateParameter(key: "limit", value: limit)
        
        return apiRequest(components: components, callback: callback)
    }
    
    /// Template: Example function to upload file request
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - photo: File that will upload
    ///   - completion: Callback response from API
    func exampleUpload(value: String, photo: Data, callback: ApiResponseCallback) {
        let components = ApiComponents(path: .path, method: .post)
        components.updateParameter(key: "parameter", value: value)
        components.updateParameter(key: "parameter", value: photo, mimeType: .jpg)
        
        uploadRequest(components: components, callback: callback)
    }
}
