//
//  SignupView.swift
//  BytePal AI, LLC
//
//  Created by may on 7/17/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI
import CoreData

struct SignupView: View {
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var signupError: String = ""
    @State var isShowingChatView: Bool = false
    
    func createAgent(id: String) {
            var err: Int = 0
            let semaphore = DispatchSemaphore (value: 0)
        
            print("------------ err 1: \(err)")
            print("agent 1")
        
            print("------- userID (create agent): \(id)")
        
            let createAgentParameter = """
            {
                \"user_id\" : "\(id)"
            }
            """
        
            print("agent 2")
            
            let postData = createAgentParameter.data(using: .utf8)
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            
            struct createAgentStruct: Decodable {
                var user_id: String
            }
        
            print("agent 3")

    //      promise handler (completion handler in Apple Dev Doc)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
    //              Parse response
                    print("agent 4")
                    let dataResponse: String = String(data: data, encoding: .utf8)!
                    
                    print("------ resposne: \(dataResponse)")
                    
                    print("------------ err 2: \(err)")
                    
                    if dataResponse != "New Agent created" {
                        
                        err = 1
                    }
                }
                semaphore.signal()
            }
        
            print("agent 5")
            task.resume()
            print("agent 6")
            semaphore.wait()
        
            print("agent 7")
            print("------------ err 3: \(err)")
        
            if err == 0 {
                print("------- Agent created")
                self.isShowingChatView = true
            } else {
                print("------- Agent ALREADY created")
            }
    }
    
    func signup () {
            print("test 3")
            let semaphore = DispatchSemaphore (value: 0)
        
            print("email: \(self.email)")
        print("password: \(self.password)")
        print("firstName: \(self.firstName)")
        print("lastName: \(self.lastName)")

            print("test 4")
            let parameters = """
            {
                \"email\": \"\(self.email)\",
                \"password\": \"\(self.password)\",
                \"first_name\": \"\(self.firstName)\",
                \"last_name\": \"\(self.lastName)\"
            }
            """
            let postData = parameters.data(using: .utf8)

            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/register")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = postData

            struct responseStruct: Decodable {
                var user_id: String
            }
        
            print("test 5")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
                    if String(data: data, encoding: .utf8)! == "User Email already Exist" {
                        print("test 6")
                        self.signupError = "User is already signed up"
                    } else {
                        // Set user id
                        print("test 7")
                        let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                        let userID: String = reponseObject.user_id
                        
                        print("test 8")
                        print("userID: \(userID)")
                        // Write user information to cache
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        print("test 9 a")
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = self.email
                        userInformationCoreDataWrite.firstName = self.firstName
                        userInformationCoreDataWrite.lastName = self.lastName
                        print("test 9 b")
                        
                        DispatchQueue.global(qos: .background).async {
                            try? self.moc.save()
                        }
                        
                        print("test 9 c")
                        
                        // Write user information to RAM
                        
                        DispatchQueue.main.async {
                            self.userInformation.id = userID
                            self.userInformation.email = self.email
                            self.userInformation.firstName = self.firstName
                            self.userInformation.lastName = self.lastName
                        }
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            self.createAgent(id: userID)
                        }
                        
                        

                    }
                } catch {
                    print(error)
                }
                semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                    Group {
                        Text("Signup")
                            .font(.custom(fontStyle, size: 32))
                            .padding(EdgeInsets(top: 96, leading: 150, bottom: 32, trailing: 150))
                        Text(self.signupError)
                            .font(.custom(fontStyle, size: 16))
                            .foregroundColor(Color(UIColor.systemRed))
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
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
                    }
                    Button(action: {
                        print("test 1")
                        
                        if self.email != "" && self.firstName != "" && self.lastName != "" && self.password != "" {
                                print("test 2")
                                self.signup()
                        }
                        else {
                            self.signupError = "Error missing signup field"
                        }
                    }){
                        Text("Signup")
                    }
                        .padding(EdgeInsets(top: 0, leading: 160, bottom: 256, trailing: 160))
                    NavigationLink(destination: ChatView().environmentObject(messages).environmentObject(userInformation), isActive: self.$isShowingChatView){EmptyView()}
                    Spacer(minLength: 320)
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
