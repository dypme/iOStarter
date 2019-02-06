//
//  DownloadRequestor.swift
//  Indomaret
//
//  Created by Crocodic MBP-2 on 11/3/17.
//  Copyright © 2017 Crocodic Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

fileprivate class Directory {
    /// Get file in directory
    ///
    /// - Parameter url: url of file
    /// - Returns: File data and full file path
    static func fileInDirectory(from url: URL) -> (data: Data?, fileUrl: String) {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask,
                                                            true)[0] as String
        let directoryUrl = URL(fileURLWithPath: directory)
        
        let fileName = url.lastPathComponent
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                let file = try Data(contentsOf: fileUrl)
                return (file, "\(directoryUrl)\(fileName)")
            } catch {
                return (nil, "")
            }
        } else {
            return (nil, "")
        }
        
    }
}

class DownloadFile {
    /// Data for resuming paused download data
    private var resumeData: Data?
    /// Result of download data
    private var downloadData: Data?
    
    /// Starting download file with string url
    ///
    /// - Parameters:
    ///   - urlString: String url of file
    ///   - progress: Download progress closure
    ///   - completion: Complete download progress closure
    func fetch(url urlString: String, progress: ((Progress) -> Void)? = nil, completion: @escaping ((Data?, String) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        
        fetch(url: url, progress: progress, completion: completion)
    }
    
    /// Starting download file
    ///
    /// - Parameters:
    ///   - url: Url of file
    ///   - progress: Download progress closure
    ///   - completion: Complete download progress closure
    func fetch(url: URL, progress: ((Progress) -> Void)? = nil, completion: @escaping ((Data?, String) -> Void)) {
        let fileDirectory = Directory.fileInDirectory(from: url)
        guard fileDirectory.data == nil else {
            completion(fileDirectory.data, fileDirectory.fileUrl)
            return
        }
        guard downloadData == nil else {
            completion(fileDirectory.data, fileDirectory.fileUrl)
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let request: DownloadRequest
        if let resumeData = resumeData {
            request = Alamofire.download(resumingWith: resumeData, to: destination).downloadProgress { (progressDownload) in
                progress?(progressDownload)
            }
        } else {
            request = Alamofire.download(url, to: destination).downloadProgress { (progressDownload) in
                progress?(progressDownload)
            }
        }
        
        request.responseData { response in
            switch response.result {
            case .success(let data):
                self.downloadData = data
                
                let fileDirectory = Directory.fileInDirectory(from: url)
                completion(fileDirectory.data, fileDirectory.fileUrl)
            case .failure:
                self.resumeData = response.resumeData
            }
        }
    }
}
