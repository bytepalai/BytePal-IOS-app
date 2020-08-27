//
//  BytepalRequest.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

class MakeRequest {
    
    static func sendMessage(message: String,
                            userID: String,
                            completion: @escaping (String, String) -> Void) {
        
        var responseFromChatBot: String?
        var voicePath : String?
        let semaphore = DispatchSemaphore (value: 0)
        //      Define header of POST Request
        let urlRequest =  "\(API_HOSTNAME)/interact"
        
        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/interact")!,
                                 timeoutInterval: Double.infinity)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //Define body of POST Request
        //let userID = "$2b$12$6r5AA4ajhiPSXJBbRVjk3eaeddkG20bNpENxaACMVljiE8yX3UqKu"
        
        let parameters: Parameters = [
            "user_id": userID,
            "text":message,
            "type":"user"
        ]
        
        print(userID)
        print("stuck")
        
        Download.downloadWav(url: urlRequest, parameters:parameters){
            response1, response2 in
            responseFromChatBot = response1
            voicePath = response2
            print("answer", responseFromChatBot!)
            completion(responseFromChatBot!, voicePath!)
            //semaphore.signal()
        }
        
        print("not stuck")
        print("response is")
        
    }
    
}
