//
//  LoginView.swift
//  SwiftUIChatMessage
//
//  Created by may on 6/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

struct LoginView: View {
    var loginViewModel: LoginViewModel = LoginViewModel()
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()
    var messageHistoryData: [[String: String]] = [[String: String]]()
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isCurrentUserLoadServer: Bool = false
    @State var TextForMultiLine: String =
        """
        """
    @State var email: String = ""
    @State var password: String = ""
    @State var loginResp: String = ""
    @State var loginError: String = ""
    @State var isShowingChatView = false
    @State var isShowingEnviromentObjectTestView = false
    
    var body: some View {
        NavigationView {
            VStack {
                LargeLogo()
                Text(loginError)
                    .foregroundColor(Color(UIColor.systemRed))
                    .font(.custom(fontStyle, size: 18))
                TextField("Enter email", text: $email)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                    .autocapitalization(.none)
                SecureField("Enter password", text: $password)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                    .autocapitalization(.none)
                Button(action: {
                    self.personalLogin(email: self.email, password: self.password)
                }){
                    LoginButtonView()
                }
                Divider()
                SignupBar()
                NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$isShowingChatView){EmptyView()}
                
            }.onAppear(perform: {
                
                // Set values on first application launch
                if UIApplication.isFirstLaunch() {
                    // Set personal login status
                    let userInformationCoreDataWrite: User = User(context: self.moc)
                    userInformationCoreDataWrite.isLoggedIn = false
                    try? self.moc.save()
                } else {
                    // Load messages from cache
                    var messageNumber: Int = 0
                    if self.MessagesCoreData.isEmpty != true {
                        let messageCount: Int = self.MessagesCoreData.count
                        let lastMessageLowestIndex: Int = messageCount - 2
                        for message in self.MessagesCoreData {
                            if messageNumber >= lastMessageLowestIndex {
                                self.messages.lastMessages.append(message.content ?? "")
                            }
                            self.loadMessageCache(message: message)
                            messageNumber += 1
                        }
                    }
                    else {
                        self.messages.lastMessages.append(userNoMessages)
                        self.messages.lastMessages.append(chatbotNoMessages)
                    }
                    
                    // Load user information from cache and go to Chat View (login)
                    if self.socialMediaAuth.getAccountLoginStatus(personalLoginStatus: self.userInformation.isLoggedIn) != "logged out" {
                        
                        // Load user information from cache to RAM
                        for userInfo in self.UserInformationCoreData {
                            self.userInformation.id = userInfo.id ?? ""
                            self.userInformation.email = userInfo.email ?? ""
                            self.userInformation.firstName = userInfo.firstName ?? ""
                            self.userInformation.lastName = userInfo.lastName ?? ""
                            self.userInformation.fullName =  (userInfo.firstName ?? "") + " " + (userInfo.lastName ?? "")
                        }
                        
                        // Go to Chat View
                        self.isShowingChatView = true
                        
                    }
                }
                
            })
        }
            .navigationBarBackButtonHidden(true)
    }
    
    func personalLogin (email: String, password: String) {

        let semaphore = DispatchSemaphore (value: 0)
        var messageHistoryData: [[String: String]] = [[String: String]]()
        var loginStatus: String = ""
        
        let parameters = "{  \n   \"email\":\"\(email)\",\n   \"password\":\"\(password)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/login")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        struct responseStruct: Decodable {
            var user_id: String
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                loginStatus = ""
                return
            }
            do {
                if String(data: data, encoding: .utf8)! == "Wrong Password" {
                    loginStatus = "Wrong email or password"
                } else {
                    
                    // Set state to logged in
                    let userInformationCoreDataWrite: User = User(context: self.moc)
                    userInformationCoreDataWrite.isLoggedIn = true
                    DispatchQueue.main.async {
                        try? self.moc.save()
                    }
                                        
                    // Set user ID
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let user_id: String = reponseObject.user_id
                    loginStatus = user_id
                    
                    // Load messages from server
                    if self.socialMediaAuth.getAccountLoginStatus(personalLoginStatus: self.userInformation.isLoggedIn) == "logged out" {
                        DispatchQueue.main.async {
                            messageHistoryData = self.messages.getHistory(userID: user_id)
                            if !messageHistoryData.isEmpty {
                                for message in messageHistoryData {
                                    self.loadMessageServer(message: message)
                                }
                            }
                            self.userInformation.id = user_id
                        }   
                    }
                    
                    if loginStatus == "Wrong email or password" {
                        self.loginError = "Wrong email or password"
                    }else {
                        // Set Personal login status, email
                        self.userInformation.isLoggedIn = true
                        self.userInformation.id = user_id
                        self.userInformation.email = self.email
                        
                        // Go to chat view
                        self.isShowingChatView = true
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
    
    func loadMessageCache(message: Message) {
        self.messages.list.insert(["id": message.id!, "content": message.content!, "isCurrentUser": message.isCurrentUser], at: self.messages.list.startIndex)
    }
    
    func loadMessageServer(message: [String: String]) {
        
        // Load messages into RAM
        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
        
        //  Toggle the user type
        isCurrentUserLoadServer.toggle()
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct LargeLogo: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 160, height: 160)
                .fixedSize()
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.35), radius: 5, x: 5, y: 7)
            Text("BytePal")
//                        .padding(16)
                .font(.custom(fontStyle, size: 32))
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.24), radius: 3, x: 3, y: 6)
                .foregroundColor(Color(UIColor.white))
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(convertHextoRGB(hexColor: "1864C4"))
                        .frame(width: 290, height: 56)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 6, y: 8)
                )
                .padding(16)
        }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
    }
}

struct LoginButtonView: View {
    var body: some View {
        Text("Login")
            .padding(8)
            .font(.custom(fontStyle, size: 20))
            .foregroundColor(Color(UIColor.black))
            .cornerRadius(15)
            .shadow(color: convertHextoRGB(hexColor: "888888").opacity(0.64), radius: 3, x: 1, y: 3)
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: 72, height: 30)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.16), radius: 6, x: -2, y: -2)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: 72, height: 30)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 5, y: 5)
                }            )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
    }
}

struct FacebookLogin: View {
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView = false

    func loginFB() {
        var email: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var fbUserInformation: [String: String] = [String: String]()
        
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
            
            // Handeler FB Login
            if let fbAccessToken = result!.token {
                let id: String = fbAccessToken.userID
                // Get user profile infromation
                let tokenString: String = fbAccessToken.tokenString    // Set FBGraphAPI token
                let request = FBSDKLoginKit.GraphRequest(               // Make FBGraphAPI request object
                    graphPath: "me",
                    parameters: ["fields": "email, name"],              // Specify data request from Facebook Graph API "User" Root Node
                    tokenString: tokenString,
                    version: nil,
                    httpMethod: .get
                )
                
                request.start(completionHandler: {connection, result, error in  // Send FBGraphAPI Request
                    
                    // Handeler for request
                    if let userProfile = result as? [String: String] {
                        // Set email
                        email = userProfile["email"]!
                        // Set names
                        let fullName = userProfile["name"]
                        let names: [String] = fullName!.components(separatedBy: " ")
                        let namesNum: Int = names.count
                        switch namesNum {
                            case 2:
                                firstName = names[0]
                                lastName = names[1]
                            case 3:
                                firstName = names[0]
                                lastName = names[2]
                            default:
                                firstName = ""
                                lastName = ""
                                print("Error no name recieved")
                        }
                        
                        fbUserInformation = BytePalAuth().facebookLogin(id: id, email: email, first_name: firstName, last_name: lastName)

                        // Saved userID if it exists
                        if fbUserInformation["id"]! != "" {
                            
                            // Create Agent
                            self.createAgent(id: fbUserInformation["id"]!)
                            
                            // Write user information to cache
                            let userInformationCoreDataWrite: User = User(context: self.moc)
                            userInformationCoreDataWrite.id = fbUserInformation["id"]!
                            userInformationCoreDataWrite.email = fbUserInformation["email"]!
                            userInformationCoreDataWrite.firstName = fbUserInformation["firstName"]!
                            userInformationCoreDataWrite.lastName = fbUserInformation["lastName"]!
                            try? self.moc.save()
                            
                            // Write user information to RAM
                            self.userInformation.id = fbUserInformation["id"]!
                            self.userInformation.email = fbUserInformation["email"]!
                            self.userInformation.firstName = fbUserInformation["firstName"]!
                            self.userInformation.lastName = fbUserInformation["lastName"]!
                            self.userInformation.fullName = fbUserInformation["firstName"]! + " " + fbUserInformation["lastName"]!
                            
                            self.isShowingChatView = true
                        }
                    }
                })
            }
        }
    }
    
    func createAgent(id: String) {
        var err: Int = 0
        let semaphore = DispatchSemaphore (value: 0)
        let createAgentParameter = """
        {
            \"user_id\" : "\(id)"
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
                // Parse response
                let dataResponse: String = String(data: data, encoding: .utf8)!

                if dataResponse != "New Agent created" {
                    err = 1
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()

        if err == 0 {
            self.isShowingChatView = true
        } else {
            print("------- Agent ALREADY created")
        }
    }
    
    var body: some View {
        Button(action: {
            self.loginFB()
        }){
            VStack {
                Text("f")
                    .font(.custom(fontStyle, size: 20))
                    .foregroundColor(Color(UIColor.white))
                    .background(
                        Circle()
                            .fill(convertHextoRGB(hexColor: "3B5998"))
                            .frame(width: 32, height: 32)
                            .shadow(color: Color(UIColor.black).opacity(0.48), radius: 4, x: 3, y: 3)
                    )
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 22))
                NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$isShowingChatView){EmptyView()}
            }
        }
    }
}

struct GoogleLogin: View {
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView = false
    
    var body: some View {
        VStack {
            Group {
                if googleDelegate.signedIn {
                    Button(action: {
                        GIDSignIn.sharedInstance().signIn()
                    }){
                        Text("G")
                            .font(.custom(fontStyle, size: 24))
                            .foregroundColor(Color(UIColor.white))
                            .background(
                                Circle()
                                    .fill(convertHextoRGB(hexColor: "DB3236"))
                                    .frame(width: 32, height: 32)
                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                                )
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    }
                } else {
                    Button(action: {
                        GIDSignIn.sharedInstance().signIn()
                    }){
                        Text("G")
                            .font(.custom(fontStyle, size: 24))
                            .foregroundColor(Color(UIColor.white))
                            .background(
                                Circle()
                                    .fill(convertHextoRGB(hexColor: "DB3236"))
                                    .frame(width: 32, height: 32)
                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                                )
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    }
                }
            }.onAppear(perform: {
                if(GIDSignIn.sharedInstance()?.currentUser != nil){

                    // Saved userID if it exists
                    if self.googleDelegate.userID != "" {
                        
                        // Write user information to cache
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = self.googleDelegate.userID
                        userInformationCoreDataWrite.email = self.googleDelegate.email
                        userInformationCoreDataWrite.firstName = self.googleDelegate.firstName
                        userInformationCoreDataWrite.lastName = self.googleDelegate.lastName
                        try? self.moc.save()
                        
                        // Write user information to RAM
                        self.userInformation.id = self.googleDelegate.userID
                        self.userInformation.email = self.googleDelegate.email
                        self.userInformation.firstName = self.googleDelegate.firstName
                        self.userInformation.lastName = self.googleDelegate.lastName
                        self.userInformation.fullName = self.googleDelegate.firstName + " " + self.googleDelegate.lastName
                        
                        self.isShowingChatView = true
                    }
                }
            })
            NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$isShowingChatView){EmptyView()}
        }
    }
}

struct PersonalLogin: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    
    var body: some View {
        NavigationLink(destination: SignupView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate)){
            Image(systemName: "envelope.fill")
                .font(.system(size: 16))
                .foregroundColor(Color(UIColor.white))
                .shadow(color: Color(UIColor.black).opacity(0.32), radius: 6, x: 3, y: 3)
                .background(
                    Circle()
                        .fill(convertHextoRGB(hexColor: "1757A8"))
                        .frame(width: 32, height: 32)
                        .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                    )
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 12))
        }
    }
}

struct SignupBar: View {
    var body: some View {
        HStack {
            Text("Register")
                .font(.custom(fontStyle, size: 20))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 48))
            FacebookLogin()
            GoogleLogin()
            PersonalLogin()
        }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 240, trailing: 0))
    }
}
