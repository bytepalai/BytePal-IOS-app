//
//  PersonalLoginView.swift
//  BytePal
//
//  Created by may on 6/30/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct title: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 160, height: 160)
                .fixedSize()
            Text("BytePal")
                .font(.custom(fontStyle, size: 32))
        }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16))
    }
}

struct login: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var erorrLogin: String = ""
    
    func createAgent(id: String) -> Int{
            var err: Int = 0
            let semaphore = DispatchSemaphore (value: 0)
            
            let createAgentParameter = """
            {
                \"user_id\" : "\(id)",
            }
            """
            
            let postData = createAgentParameter.data(using: .utf8)
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            
            struct createAgentStruct: Decodable {
                var user_id: String
            }

    //      promise handler (completion handler in Apple Dev Doc)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
    //              Parse response
                    let dataResponse: String = String(data: data, encoding: .utf8)!
                    if dataResponse != "New Agent created" {
                        err = 1
                    }
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            return err
    }
        
    func login(email: String, password: String) -> String {
        var userID: String?
        let semaphore = DispatchSemaphore (value: 0)
        
        let loginParameters = """
        {
            \"email\" : \"\(email)\",
            \"password\" : "\(password)\",
        }
        """
        
        let postData = loginParameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/login")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        struct userIDStruct: Decodable {
            var user_id: String
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let reponseObject = try JSONDecoder().decode(userIDStruct.self, from: data)
                let responseData: String = reponseObject.user_id
                userID = responseData
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return userID!
    }

    var body: some View {
        GeometryReader {geometry in
            VStack (alignment: .center) {
                TextField("email", text: self.$email)
                    .frame(width: 375/2, height: 16)
                    .padding(8)
                TextField("password", text: self.$password)
                    .frame(width: 375/2, height: 16)
                    .padding(8)
                Button(action: {
                    let id: String = self.login(email: self.email, password: self.password)
                    if self.createAgent(id: id) == 1 {
                        self.erorrLogin = "Username or password incorrect"
                    }
                    else {
                        
                    }
                }) {
                    Text("Login").font(.custom(fontStyle, size: 20))
                }
                    .padding(8)
                Text("\(self.erorrLogin)")
                    .padding(32)
                    .font(.custom(fontStyle, size: 20))
                    .foregroundColor(Color(UIColor.systemRed))
            }
        }
    }
}

struct PersonalLoginView: View {
    var body: some View {
        VStack {
            title()
            login()
        }
    }
}

struct PersonalLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalLoginView()
    }
}
