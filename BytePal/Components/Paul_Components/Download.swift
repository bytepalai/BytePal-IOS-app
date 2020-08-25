//
//  Download.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation

class Download {
    
    static func downloadWav(url: String, parameters:Parameters,
                            completion: @escaping (String, String) -> Void) {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("voice.wav")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            
        }
        
        AF.download(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            to: destination)
            .downloadProgress(closure: { (progress) in
                //progress closure
                
            })
            .responseData { response in
                
                if response.error == nil, let voicePath = response.fileURL?.path {
                    if let message = response.response?.allHeaderFields["message"] as? String {
                        completion(message, voicePath)
                    }
                    
                }
        }
        
    }
    
}
