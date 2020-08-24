//
//  API.swift
//  BytePal
//
//  Created by may on 7/12/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

func loginApp() {
    let semaphore = DispatchSemaphore (value: 0)

    let parameters = """
    {
        \"email\" : \"scott@gmail.com\",
        \"password\" : "password123",
    }
    """
    
    let dataPOST = parameters.data(using: .utf8)
    var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/login")!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = dataPOST

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
}

func createAgent() {
    let semaphore = DispatchSemaphore (value: 0)

    let parameters = """
    {
        \"user_id\" : \"$2b$12$nIYu6jFKoYBF7KXbku9k5.f/LvbhMW7TpXANOEsKGPUXWhHEQOUWu\"
    }
    """
    
    let dataPOST = parameters.data(using: .utf8)
    var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = dataPOST

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
}
