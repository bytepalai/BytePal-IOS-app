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
            var request = URLRequest(url: URL(string: "\(TEST_SERVER_API_HOSTNAME)/messages_left")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
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
                    print(String(describing: error))
                    return
                }
                do {
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let responseData: String = reponseObject.messages_left
                    messagesLeftResponse = responseData.trimmingCharacters(in: .whitespacesAndNewlines)
                } catch {
                    print(error)
                }
                semaphore.signal()
            }
        
            task.resume()
            semaphore.wait()
            
            // Return loginStatus
            return messagesLeftResponse!
    }
        
    func getMessagesLeft() -> Int{
        var messagesLeftNum: Int = -1
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "http://\(TEST_SERVER_API_HOSTNAME)/messages_left")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            messagesLeftNum = Int(String(data: data, encoding: .utf8)!) ?? -1
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return messagesLeftNum
    }

}
