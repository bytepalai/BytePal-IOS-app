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
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

struct LoginView: View {
    // Controller both views
    @State var isHiddenLoginView: Bool = false
    @State var isHiddenSignupView: Bool = true
    
    // Login View
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
    @State var rootViewIsActive: Bool = false
    @State var isCurrentUserLoadServer: Bool = true
    @State var TextForMultiLine: String =
        """
        """
    @State var email: String = ""
    @State var password: String = ""
    @State var loginResp: String = ""
    @State var loginError: String = ""
    @State var isShowingChatView = false
    @State var isShowingEnviromentObjectTestView = false
    
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
            NavigationView {
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
                        rootViewIsActive: self.$rootViewIsActive,
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenSignupView: self.$isHiddenSignupView
                    )
                    
                }.onAppear(perform: {
                    self.onAppearLoginView()
                })
            }
                .navigationBarBackButtonHidden(true)
                .isHidden(self.isHiddenLoginView, remove: isHiddenLoginView)
        }
            
        // Signup View
        SignupView(
            rootViewIsActive: self.$rootViewIsActive,
            isHiddenLoginView: self.$isHiddenLoginView,
            isHiddenSignupView: self.$isHiddenSignupView
        )
            .isHidden(self.isHiddenSignupView, remove: self.isHiddenSignupView)
        
        NavigationLink(destination: ChatView(rootViewIsActive: self.$rootViewIsActive).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$rootViewIsActive){EmptyView()}
                .isDetailLink(false)
        
    }
    
    func onAppearLoginView() {
        
        // Test
        NetworkStatus.getNetworkStatus()
        
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
                    print("-------------------- CACHE --------------------- ")
                    var messageNumber: Int = 0
                    if self.MessagesCoreData.isEmpty != true {
                        let messageCount: Int = self.MessagesCoreData.count
                        let lastMessageLowestIndex: Int = messageCount - 2
                        
                        for message in self.MessagesCoreData {
                            print("message")
                            if messageNumber >= lastMessageLowestIndex {
                                self.messages.lastMessages.append(message.content ?? "")
                            }
                            self.loadMessageHistoryCache(message: message)
                            messageNumber += 1
                        }
                    }
                    else {
                        self.messages.lastMessages.append(userNoMessages)
                        self.messages.lastMessages.append(chatbotNoMessages)
                    }
                }
            })

            // Load user information from cache and go to Chat View (login)
            if self.socialMediaAuth.getAccountLoginStatus(personalLoginStatus: self.userInformation.isLoggedIn) != "logged out" {
                
                // Load user information from cache to RAM
                for userInfo in self.UserInformationCoreData {
                    self.userInformation.id = userInfo.id ?? "Error: ID not unwrapped succesfully onAppearLoginView()"
                    self.userInformation.email = userInfo.email ?? ""
                    self.userInformation.firstName = userInfo.firstName ?? ""
                    self.userInformation.lastName = userInfo.lastName ?? ""
                    self.userInformation.fullName =  (userInfo.firstName ?? "") + " " + (userInfo.lastName ?? "")
                }
                
                // Go to Chat View
                self.rootViewIsActive = true
                
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
        
        // Send request
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
                    // Set state to logged in
                    let userInformationCoreDataWrite: User = User(context: self.moc)
                    userInformationCoreDataWrite.isLoggedIn = true
                    
                    DispatchQueue.main.async {
                        try? self.moc.save()
                    }
                    
                                        
                    // Set user ID
                    do {
                        let responseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                        let user_id: String = responseObject.user_id
                        loginStatus = user_id
                        print("------- personal: \(user_id)")

                        // Load messages from server
                        NetworkStatus.checkNetworkStatus(completion: { netStat in
                            if netStat["status"] == true {
                                print("-------------------- SERVER --------------------- ")
                                
                                DispatchQueue.main.async {
                                    // Update messages
                                    self.updateMessageHistoryServer(userID: user_id)
                                    
                                    // Set user id
                                    self.userInformation.id = user_id
                                }
                            }
                        })
    
                        // Set Personal login status, email
                        DispatchQueue.main.async {
                            self.userInformation.isLoggedIn = true
                            self.userInformation.id = user_id
                            self.userInformation.email = self.email
                        }
                        
                        // Clear states
                        self.email = ""
                        self.password = ""
                        self.loginResp = ""
                        self.loginError = ""
                        
                        // Go to chat view
                        self.rootViewIsActive = true
                    }
                    catch let err {
                        print(err)
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
    
    func loadMessageHistoryCache(message: Message) {
        if message.id != nil {
            self.messages.list.insert(["id": message.id!, "content": message.content!, "isCurrentUser": message.isCurrentUser], at: self.messages.list.startIndex)
        } else {
            print("-------- Error: Unable to unwrap message ID. message = \(message) for /BytePal/Screens/Authentication/LoginView.swift")
        }
        
    }
    
    func updateMessageHistoryServer(userID: String) {
        var messageHistoryData: [[String: String]] = [[String: String]]()
        
        // Clear message cache
        for message in MessagesCoreData {
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
