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

typealias Callback = ((JSON, Bool, String) -> Void)?

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
    var headers: [String : String] {
        let data : [String : String] = [ : ]
        return data
    }
    
    /// Create full url API
    func setUrl(path: Path) -> URL {
        return URL(string: BASE_URL + path.rawValue)!
    }
    
    /// Alamofire session manager is Alamfire with some configuration of url session configuration
    private var afManager: SessionManager? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    // MARK: - Function call method helper
    /// Make API request to server
    /// - Parameters:
    ///   - path: Path url API
    ///   - method: Method when requesting API
    ///   - parameters: Parameters used in requesting
    ///   - completion: Callback response from API
    private func apiRequest(path: Path, method: Alamofire.HTTPMethod, parameters: Parameters, completion: Callback) -> DataRequest? {
        let url = setUrl(path: path)
        return apiRequest(url: url, method: method, parameters: parameters, completion: completion)
    }
    
    /// Make API request to server
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: Parameters used in requesting
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    private func apiRequest(url: URL, method: Alamofire.HTTPMethod, parameters: Parameters, completion: Callback) -> DataRequest? {
        return afManager?.request(url, method: method, parameters: parameters, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                print("Get response request : \(response.result.value ?? "")")
                if let data = response.data {
                    let json = try! JSON(data: data)
                    let status = json["api_status"].intValue
                    let message = json["api_message"].stringValue
                    completion?(json, status == 1, message)
                }
            } else {
                if let error = response.result.error {
                    completion?("", false, error.localizedDescription)
                    return
                }
                print(response.result.debugDescription)
                completion?("", false, "Terjadi suatu kesalahan")
            }
        }
    }
    
    /// Upload data to server
    /// - Parameters:
    ///   - path: Path url API
    ///   - method: Method when requesting API
    ///   - parameters: All parameters needed when requesting, recomended using only 2 data type (String and Data), Data used for file to upload
    ///   - completion: Callback response from API
    private func uploadRequest(path: Path, method: Alamofire.HTTPMethod, parameters: UploadParameters, completion: Callback) {
        let url = setUrl(path: path)
        uploadRequest(url: url, method: method, parameters: parameters, completion: completion)
    }
    
    /// Upload data to server
    /// - Parameters:
    ///   - url: Full url API
    ///   - method: Method when requesting API
    ///   - parameters: All parameters needed when requesting, recomended using only 2 data type (String and Data), Data used for file to upload
    ///   - completion: Callback response from API
    private func uploadRequest(url: URL, method: Alamofire.HTTPMethod, parameters: UploadParameters, completion: Callback) {
        afManager?.upload(multipartFormData: { (multipartFormData) in
            for (key, value, mimeType) in parameters {
                if let data = value as? Data, let mimeType = mimeType {
                    multipartFormData.append(data, withName: key, fileName: mimeType.generateFileName, mimeType: mimeType.value)
                } else if let strData = "\(value)".data(using: .utf8) {
                    multipartFormData.append(strData, withName: key)
                }
            }
        }, to: url, method: method, headers: headers) { (encodingResult) in
            switch encodingResult{
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        print("Get response request : \(response.result.value ?? "")")
                        if let data = response.data {
                            let json = try! JSON(data: data)
                            let status = json["api_status"].intValue
                            let message = json["api_message"].stringValue
                            completion?(json, status == 1, message)
                        }
                    } else {
                        print(response.result.debugDescription)
                        completion?("", false, "Terjadi suatu kesalahan")
                    }
                })
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                completion?("", false, encodingError.localizedDescription)
            }
        }
    }
    
    // MARK: - Example
    /// Template: Example function to request API
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func example(value: String, completion: Callback) -> DataRequest? {
        var parameters = Parameters()
        parameters.updateValue(value, forKey: "parameter")
        
        let url = setUrl(path: .path)
        
        return apiRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
    
    /// Template: Example function to request API with response as list
    ///
    /// - Parameters:
    ///   - searchText: Search text to find specific name
    ///   - limit: Limit response array every page
    ///   - offset: Number of page in list
    ///   - completion: Callback response from API
    /// - Returns: Data when requesting
    func exampleList(searchText: String, limit: Int, offset: Int, completion: Callback) -> DataRequest? {
        var parameters = Parameters()
        parameters.updateValue(searchText, forKey: "search")
        parameters.updateValue(offset, forKey: "offset")
        parameters.updateValue(limit, forKey: "limit")
        
        return apiRequest(path: .path, method: .get, parameters: parameters, completion: completion)
    }
    
    /// Template: Example function to upload file request
    ///
    /// - Parameters:
    ///   - value: Value of parameters required
    ///   - photo: File that will upload
    ///   - completion: Callback response from API
    func exampleUpload(value: String, photo: Data, completion: Callback) {
        var parameters = UploadParameters()
        parameters.updateValue(value, forKey: "parameter")
        parameters.updateValue(photo, forKey: "parameter", mimeType: .jpg)
        
        let url = setUrl(path: .path)
        
        uploadRequest(url: url, method: .post, parameters: parameters, completion: completion)
    }
}
