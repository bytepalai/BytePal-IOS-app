//
//  MessagesController.swift
//  BytePal
//
//  Created by may on 8/27/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

extension Messages {
    
    func getMessagesLeft(userID: String) -> String {
            var messagesLeftResponse: String?
            let semaphore = DispatchSemaphore (value: 0)

    //      Define header of POST Request
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/messages_left")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            print("---- FB (REQUEST): \(userID)")
        
    //      Define body of POST Request
            let parameters = """
            {
            \"user_id\": \"\(userID)\"
            }
            """
            let dataPOST = parameters.data(using: .utf8)
            request.httpBody = dataPOST
            
    //      Define JSON response format
            struct responseStruct: Decodable {
                var messages_left: String
            }

    //      Create POST Request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //          Handle response
                guard let data = data else {
                    print("----- test 1")
                    print(String(describing: error))
                    return
                }
                do {
                    print("----- test 2")
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    print("----- test 3")
                    let responseData: String = reponseObject.messages_left
                    print("----- test 4")
                    messagesLeftResponse = responseData.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("----- test 5")
                } catch {
                    print("----- test 6")
                    print(error)
                    print("----- test 7")
                }
                semaphore.signal()
            }
            print("----- test 8")
            task.resume()
            print("----- test 9")
            semaphore.wait()
            print("----- test 10")
            // Return loginStatus
            return messagesLeftResponse!
    }
}
