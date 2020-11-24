//
//  LoginView.swift
//  SwiftUIChatMessage
//
//  Created by Scott Hom on 6/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

struct LoginView: View {
    // Controller both views
    @State var isHiddenLoginView: Bool = false
    @State var isHiddenSignupView: Bool = true
    @State var isHiddenChatView: Bool = true
    
    // Login View
    
    //
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()
    var messageHistoryData: [[String: String]] = [[String: String]]()
    
    // Core Data
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    
    // Environment Object
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    
    // States
    @State var isCurrentUserLoadServer: Bool = true
    @State var TextForMultiLine: String =
        """
        """
    @State var email: String = ""
    @State var password: String = ""
    @State var loginResp: String = ""
    @State var loginError: String = ""
    
    // Signup (Hidden View, initial state)
    @State var emailSignup: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var passwordSignup: String = ""
    @State var isShowingSignupError: Bool = false
    @State var signupError: String = ""
    private let cornerRadious: CGFloat = 8
    private let buttonHeight: CGFloat = 60
    let cornerRadiusTextField: CGFloat = 15.0
    let viewHeightTextField: CGFloat = 75
    let mainViewSpacing: CGFloat = 60
    let textFieldSpace: CGFloat = 30
    let backgroundBlurRadious: CGFloat = 400
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    
                    LargeLogo(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    Text(loginError)
                        .foregroundColor(Color(UIColor.systemRed))
                        .font(.custom(fontStyle, size: 18))
                    TextField("Enter email", text: $email)
                        .padding(EdgeInsets(top: 0, leading: geometry.size.width*0.04, bottom: geometry.size.width*0.02, trailing: 0))
                        .autocapitalization(.none)
                    SecureField("Enter password", text: $password)
                        .padding(EdgeInsets(top: 0, leading: geometry.size.width*0.04, bottom: geometry.size.width*0.02, trailing: 0))
                        .autocapitalization(.none)
                    Button(action: {
                        self.personalLogin(email: self.email, password: self.password)
                    }){
                        LoginButtonView(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                    }
                    DividerCustom(
                        color: Color(UIColor.black).opacity(0.60),
                        length: Float(geometry.size.width)*(7/10),
                        width: 1
                    )
                    SignupBar(
                        width: geometry.size.width,
                        height: geometry.size.width,
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenChatView: self.$isHiddenChatView,
                        isHiddenSignupView: self.$isHiddenSignupView
                    )
                    
                }
                    .onAppear(perform: {
                        self.onAppearLoginView()
                    })
                    .isHidden(self.isHiddenLoginView, remove: isHiddenLoginView)
                    .zIndex(2)
                
                // Signup View
                SignupView(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    isHiddenLoginView: self.$isHiddenLoginView,
                    isHiddenChatView: self.$isHiddenChatView,
                    isHiddenSignupView: self.$isHiddenSignupView
                )
                    .isHidden(self.isHiddenSignupView, remove: self.isHiddenSignupView)
                    .zIndex(1)
                
                // Chat View
                ChatView(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    isHiddenLoginView: self.$isHiddenLoginView
                )
                    .isHidden(self.isHiddenChatView, remove: self.isHiddenChatView)
                    .zIndex(0)
            }
            
        }

    }
    
    func onAppearLoginView() {
        
        print("------ Login View State: \(self.isHiddenLoginView)")
        
        // Set values on first application launch
        if UIApplication.isFirstLaunch() {
            let userInformationCoreDataWrite: User = User(context: self.moc)
            userInformationCoreDataWrite.isLoggedIn = false
            try? self.moc.save()
        } else {
            // Set current view
            userInformation.currentView = "Login"

            // Load messages from cache
            NetworkStatus.checkNetworkStatus(completion: {netStat in
                let isNotConnected: Bool = !netStat["status"]!

                if userInformation.currentView == "Login" &&  isNotConnected {
                    print("Loading messages from cache ...")
                    var messageNumber: Int = 0
                    if self.MessagesCoreDataRead.isEmpty != true {
                        let messageCount: Int = self.MessagesCoreDataRead.count
                        let lastMessageLowestIndex: Int = messageCount - 2
                        
                        for message in self.MessagesCoreDataRead {
                            if messageNumber >= lastMessageLowestIndex {
                                self.messages.lastMessages.append(message.content ?? "")
                            }
                            self.loadMessageHistoryCache(message: message)
                            messageNumber += 1
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.messages.lastMessages.append(userNoMessages)
                            self.messages.lastMessages.append(chatbotNoMessages)
                        }
                    }
                }
            })

            // Load user information from cache and go to Chat View (login)
            if self.socialMediaAuth.getAccountLoginStatus(personalLoginStatus: self.userInformation.isLoggedIn) != "logged out" {
                // Load user information from cache to RAM
                for userInfo in self.UserInformationCoreDataRead {
                    self.userInformation.id = userInfo.id ?? "Error: ID not unwrapped succesfully onAppearLoginView()"
                    self.userInformation.email = userInfo.email ?? ""
                    self.userInformation.firstName = userInfo.firstName ?? ""
                    self.userInformation.lastName = userInfo.lastName ?? ""
                    self.userInformation.fullName =  (userInfo.firstName ?? "") + " " + (userInfo.lastName ?? "")
                }
                
                // Go to Chat View
                self.isHiddenLoginView = true
                
            }
        }
    }
    
    func personalLogin (email: String, password: String) {
        // Init login status
        var loginStatus: String = ""
        
        // Init request
        let semaphore = DispatchSemaphore (value: 0)
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
                    self.loginError = "Wrong email or password"
                } else {
                    // Parse Login endpoint response
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let user_id: String = reponseObject.user_id
                    loginStatus = user_id
                    
                    // Check IAP Subscription
                    IAPManager.shared.initIAP(userID: user_id)
                    
                    // Save user information to cache
                    if UserInformationCoreDataRead.count == 0 {
                        // Is not logged in
                        
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.isLoggedIn = true
                        userInformationCoreDataWrite.id = user_id
                        userInformationCoreDataWrite.email = email
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                        // Is logged (After termination)
                        
                        for userInformation in UserInformationCoreDataRead {
                            moc.delete(userInformation)
                        }
                        
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.isLoggedIn = true
                        userInformationCoreDataWrite.id = user_id
                        userInformationCoreDataWrite.email = email
                        
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    }
                    
                    print("------ email(TextField): \(self.email)")
                    
                    // Save user information to RAM
                    DispatchQueue.main.async {
                        self.userInformation.isLoggedIn = true
                        self.userInformation.id = user_id
                        self.userInformation.email = self.email
                    }

                    // if connected to a network, load messages from server.
                    NetworkStatus.checkNetworkStatus(completion: { netStat in
                        
                        if netStat["status"] == true {
                            print("Loading messages from server ...")
                            
                            DispatchQueue.main.async {
                                
                                // Update messages
                                self.updateMessageHistoryServer(userID: user_id)
                                
                            }
                            
                        }
                        
                    })

                    // Clear LoginView states
                    self.email = ""
                    self.password = ""
                    self.loginResp = ""
                    self.loginError = ""
                    
                    // Go to chat view
                    self.isHiddenLoginView = true
                    self.isHiddenSignupView = true
                    self.isHiddenChatView = false
                    
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
    }
    
    func loadMessageHistoryCache(message: Message) {
        
        if message.id != nil {
            self.messages.list.insert(["id": message.id!, "content": message.content!, "isCurrentUser": message.isCurrentUser], at: self.messages.list.startIndex)
        } else {
            print("-------- Error: Unable to unwrap message ID. message = \(message) for /BytePal/Screens/Authentication/LoginView.swift")
        }
        
    }
    
    func updateMessageHistoryServer(userID: String) {
        var messageHistoryData: [[String: String]] = [[String: String]]()
        
        print("----------- load SERVER")
        
        // Clear message cache
        for message in MessagesCoreDataRead {
            moc.delete(message)
        }
        try? self.moc.save()
        
        // Get messages from server
        messageHistoryData = self.messages.getHistory(userID: userID)
        
        // Load messages
        if !messageHistoryData.isEmpty {
            for message in messageHistoryData {
                self.loadMessageServer(message: message)
            }
        }
    }
    
    func loadMessageServer(message: [String: String]) {
        // Load messages into RAM
        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
        
        //  Toggle the user type
        isCurrentUserLoadServer.toggle()
    }
    
}
