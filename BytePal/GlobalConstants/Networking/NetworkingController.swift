//
//  NetworkingController.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

class Networking {
    
    enum endpoinType {
        case login
        case register
        case interact
    }
    
//    func post(endpointName: String, data: [String: String]) ->
//        String {
//        let semaphore = DispatchSemaphore (value: 0)
//        var errorMessage = ""
//
//        let parameters = self.createJSON(data: data)
//        let postData = parameters.data(using: .utf8)
//        var request = URLRequest(url: URL(string: "https://webhook.site/4f91114f-dd94-4561-8e53-f25051252002")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("laravel_session=FxGC1WedUank4QrxSoXk1QyW2t0ZmFrN7tW7gRbg", forHTTPHeaderField: "Cookie")
//
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    guard let data = data else {
//                        print(String(describing: error))
//                        return
//                    }
//                    do {
//                        if String(data: data, encoding: .utf8)! == "Wrong Password" {
//                            print(" --------------- Wrong Password ---------------")
//                            errorMessage = "Wrong email or password"
//                        } else {
//                            // Set user_id
//                            let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
//                            let user_id: String = reponseObject.user_id
//
//                            print(" --------------- USER ID Response \(user_id) ---------------")
//                            self.userInfo.user_id = user_id
//        //              Go to ChatView
//                            self.isShowingChatView = true
//                        }
//                    } catch {
//                        print(error)
//                    }
//                    semaphore.signal()
//                }
//
//        task.resume()
//        semaphore.wait()
//    }
    
    func createJSON(data: [String: String]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: data)
        let jsonNSString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let jsonString = jsonNSString! as String
        return jsonString
    }
}
