//
//  ApiInterceptor.swift
//  iOStarter
//
//  Created by MBP2022_1 on 02/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import Alamofire

class ApiInterceptor: RequestInterceptor {
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    // Set access token on header or get request token first
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: "ACCESS_TOKEN"))
        completion(.success(urlRequest))
    }
    
    // Handle error for automatic retry or need to refresh token first before retry
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        if let statusCode = response?.statusCode,
           (500...599).contains(statusCode),
           request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
            return
        }
        completion(.doNotRetry)
    }
}
