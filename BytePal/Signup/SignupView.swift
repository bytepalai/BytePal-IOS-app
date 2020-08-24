//
//  SignupView.swift
//  BytePal AI, LLC
//
//  Created by may on 7/17/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var signupError: String = ""
    @State var isShowingChatView: Bool = false
    @EnvironmentObject var userInfo: UserInformation
    @EnvironmentObject var messages: Messages
    
    func printResults() {
        print("\(self.email) \(self.firstName) \(self.lastName) \(self.password)")
    }
    
//    func signup (email: String, password: String) {
//            let semaphore = DispatchSemaphore (value: 0)
//
//            let parameters = """
//            {
//                \"email\": \"\(self.email)\",
//                \"password\": \"\(self.password)\",
//                \"first_name\": \"\(self.firstName)\",
//                \"last_name\": \"\(self.lastName)\"
//            }
//            """
//            let postData = parameters.data(using: .utf8)
//
//            var request = URLRequest(url: URL(string: "https://api.bytepal.io/login")!,timeoutInterval: Double.infinity)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            request.httpMethod = "POST"
//            request.httpBody = postData
//
//            struct responseStruct: Decodable {
//                var user_id: String
//            }
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print(String(describing: error))
//                    return
//                }
//                do {
//                    if String(data: data, encoding: .utf8)! == "User Email already Exist" {
//                        self.signupError = "User is already signed up"
//                    } else {
//                        // Set user_id
//                        let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
//                        let user_id: String = reponseObject.user_id
//                        self.userInfo.user_id = user_id
//    //              Go to ChatView
//                        self.isShowingChatView = true
//                    }
//                } catch {
//                    print(error)
//                }
//                semaphore.signal()
//            }
//
//            task.resume()
//            semaphore.wait()
//        }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                            Text("Signup")
                                .font(.custom(fontStyle, size: 32))
                                .padding(EdgeInsets(top: 96, leading: 150, bottom: 64, trailing: 150))
            //                Text("")
            //                    .foregroundColor(Color(UIColor.systemRed))
            //                    .font(.custom(fontStyle, size: 18))
                            Text("Email Address")
                                .font(.custom(fontStyle, size: 16))
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                            TextField("myemail@domain.com", text: $email)
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                                .autocapitalization(.none)
                            Text("First Name")
                                .font(.custom(fontStyle, size: 16))
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                            TextField("First Name", text: $firstName)
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                            Text("Last Name")
                                .font(.custom(fontStyle, size: 16))
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                            TextField("First Name", text: $lastName)
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                            Text("Password")
                                .font(.custom(fontStyle, size: 16))
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                            SecureField("Enter Password", text: $password)
                                .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                            Button(action: {
                                self.printResults()
                            }){
                                Text("Signup")
                            }
                                .padding(EdgeInsets(top: 0, leading: 160, bottom: 256, trailing: 160))
                            
//                            NavigationLink(destination:ChatView().environmentObject(messages).environmentObject(userInfo), isActive: self.$isShowingChatView){EmptyView()}
//
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
