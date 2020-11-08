//
//  SignupBar.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

//// SignupBar (height: 40%)
//struct SignupBar: View {
//    var width: CGFloat?
//    var height: CGFloat?
//    @Binding var rootViewIsActive: Bool
//    @Binding var isHiddenLoginView: Bool
//    @Binding var isHiddenSignupView: Bool
//
//    var body: some View {
//        HStack {
//
//            // SignupBar (height: 10%, heighest is TextView)
//            Text("Register")
//                .font(.custom(fontStyle, size: 20))
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: (width ?? CGFloat(100))*0.10))
//            FacebookLoginButton(
//                width: width,
//                rootViewIsActive: self.$rootViewIsActive
//            )
//            GoogleLoginButton(
//                width: width,
//                rootViewIsActive: self.$rootViewIsActive
//            )
//            PersonalLoginButton(
//                width: width,
//                rootViewIsActive: self.$rootViewIsActive,
//                isHiddenLoginView: self.$isHiddenLoginView,
//                isHiddenSignupView: self.$isHiddenSignupView
//            )
//        }
//            .padding(EdgeInsets(top: 0, leading: 0, bottom: (height ?? CGFloat(200))*0.30, trailing: 0))
//    }
//}
//
//// FacebookLoginButton (height: 7%)
//struct FacebookLoginButton: View {
//    var width: CGFloat?
//    var container: NSPersistentContainer!
//    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
//    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
//    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var userInformation: UserInformation
//    @EnvironmentObject var googleDelegate: GoogleDelegate
//    @State var isShowingChatView = false
//    @State var isCurrentUserLoadServer: Bool = true
//    @Binding var rootViewIsActive: Bool
//
//    var body: some View {
//        Button(action: {
//            self.loginFB(completion: { id in
//
//                // Load messages from server
//                NetworkStatus.checkNetworkStatus(completion: { netStat in
//
//                    print("-------- NetStat Completion: \(netStat)")
//
//                    if netStat["status"] == true {
//                        print("-------------------- SERVER (Facebook) --------------------- ")
//
//                        DispatchQueue.main.async {
//                            // Update messages
//                            self.updateMessageHistoryServer(userID: id)
//                            self.rootViewIsActive = true
//                            print("------ change root view: \(self.rootViewIsActive)")
//                        }
//                    }
//                })
//            })
//        }){
//            VStack {
//                Text("f")
//                    .font(.custom(fontStyle, size: 20))
//                    .foregroundColor(Color(UIColor.white))
//                    .background(
//                        Circle()
//                            .fill(convertHextoRGB(hexColor: "3B5998"))
//                            .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
//                            .shadow(color: Color(UIColor.black).opacity(0.48), radius: 4, x: 3, y: 3)
//                    )
//                        .padding([.trailing], (width ?? CGFloat(100))*0.05)
//                NavigationLink(destination: ChatView(rootViewIsActive: self.$rootViewIsActive).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$rootViewIsActive){EmptyView()}
//                        .isDetailLink(false)
//            }
//        }
//    }
//
//    func loginFB(completion: @escaping(String) -> Void) {
//        var email: String = ""
//        var firstName: String = ""
//        var lastName: String = ""
//        var fbUserInformation: [String: String] = [String: String]()
//
//        let fbLoginManager: LoginManager = LoginManager()
//        fbLoginManager.logOut()
//        fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
//
//            // Handeler FB Login
//            if let fbAccessToken = result!.token {
//                let id: String = fbAccessToken.userID
//                // Get user profile infromation
//                let tokenString: String = fbAccessToken.tokenString    // Set FBGraphAPI token
//                let request = FBSDKLoginKit.GraphRequest(               // Make FBGraphAPI request object
//                    graphPath: "me",
//                    parameters: ["fields": "email, name"],              // Specify data request from Facebook Graph API "User" Root Node
//                    tokenString: tokenString,
//                    version: nil,
//                    httpMethod: .get
//                )
//
//                request.start(completionHandler: {connection, result, error in  // Send FBGraphAPI Request
//
//                    // Handeler for request
//                    if let userProfile = result as? [String: String] {
//                        // Set email
//                        email = userProfile["email"]!
//                        // Set names
//                        let fullName = userProfile["name"]
//                        let names: [String] = fullName!.components(separatedBy: " ")
//                        let namesNum: Int = names.count
//                        switch namesNum {
//                            case 2:
//                                firstName = names[0]
//                                lastName = names[1]
//                            case 3:
//                                firstName = names[0]
//                                lastName = names[2]
//                            default:
//                                firstName = ""
//                                lastName = ""
//                                print("Error no name recieved")
//                        }
//
//                        fbUserInformation = BytePalAuth().facebookLogin(id: id, email: email, first_name: firstName, last_name: lastName)
//
//                        print("------------ FB(ID): \(fbUserInformation["id"]!)")
//
//                        // Saved userID if it exists
//                        if fbUserInformation["id"]! != "" {
//                            print("------- facebook: \(fbUserInformation["id"]!)")
//
//                            // Create Agent
//                            self.createAgent(id: fbUserInformation["id"]!)
//
//                            // Write user information to cache
//                            let userInformationCoreDataWrite: User = User(context: self.moc)
//                            userInformationCoreDataWrite.id = fbUserInformation["id"]!
//                            userInformationCoreDataWrite.email = fbUserInformation["email"]!
//                            userInformationCoreDataWrite.firstName = fbUserInformation["firstName"]!
//                            userInformationCoreDataWrite.lastName = fbUserInformation["lastName"]!
//                            try? self.moc.save()
//
//                            // Write user information to RAM
//                            self.userInformation.id = fbUserInformation["id"]!
//                            self.userInformation.email = fbUserInformation["email"]!
//                            self.userInformation.firstName = fbUserInformation["firstName"]!
//                            self.userInformation.lastName = fbUserInformation["lastName"]!
//                            self.userInformation.fullName = fbUserInformation["firstName"]! + " " + fbUserInformation["lastName"]!
//
//                            completion(fbUserInformation["id"]!)
//                        }
//                    }
//                })
//            }
//        }
//    }
//
//    func createAgent(id: String) {
//        var err: Int = 0
//        let semaphore = DispatchSemaphore (value: 0)
//        let createAgentParameter = """
//        {
//            \"user_id\" : "\(id)"
//        }
//        """
//
//        let postData = createAgentParameter.data(using: .utf8)
//        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = postData
//
//        struct createAgentStruct: Decodable {
//            var user_id: String
//        }
//
//        //      promise handler (completion handler in Apple Dev Doc)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                return
//            }
//            do {
//                // Parse response
//                let dataResponse: String = String(data: data, encoding: .utf8)!
//
//                if dataResponse != "New Agent created" {
//                    err = 1
//                }
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
//
//        if err == 0 {
//            self.rootViewIsActive = true
//        } else {
//            print("Agent ALREADY created")
//        }
//    }
//
//    func updateMessageHistoryServer(userID: String) {
//        var messageHistoryData: [[String: String]] = [[String: String]]()
//
//        // Clear message cache
//        for message in MessagesCoreData {
//            moc.delete(message)
//        }
//        try? self.moc.save()
//
//        // Get messages from server
//        messageHistoryData = self.messages.getHistory(userID: userID)
//
//        // Load messages
//        if !messageHistoryData.isEmpty {
//            for message in messageHistoryData {
//                self.loadMessageServer(message: message)
//            }
//        }
//    }
//
//    func loadMessageServer(message: [String: String]) {
//        // Load messages into RAM
//        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
//
//        //  Toggle the user type
//        isCurrentUserLoadServer.toggle()
//    }
//
//}
//
//
//// GoogleLoginButton (height: 7%)
//struct GoogleLoginButton: View {
//    var width: CGFloat?
//    var container: NSPersistentContainer!
//    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
//    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
//    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var userInformation: UserInformation
//    @EnvironmentObject var googleDelegate: GoogleDelegate
//    @Binding var rootViewIsActive: Bool
//    @State var isShowingChatView = false
//    @State var isCurrentUserLoadServer = true
//
//    var body: some View {
//        VStack {
//            Group {
//                if googleDelegate.signedIn {
//                    Button(action: {
//                        GIDSignIn.sharedInstance().signIn()
//                    }){
//                        Text("G")
//                            .font(.custom(fontStyle, size: 24))
//                            .foregroundColor(Color(UIColor.white))
//                            .background(
//                                Circle()
//                                    .fill(convertHextoRGB(hexColor: "DB3236"))
//                                    .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
//                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
//                            )
//                                .padding([.leading, .trailing], (width ?? CGFloat(100))*0.03)
//                    }
//                } else {
//                    Button(action: {
//                        GIDSignIn.sharedInstance().signIn()
//                    }){
//                        Text("G")
//                            .font(.custom(fontStyle, size: 24))
//                            .foregroundColor(Color(UIColor.white))
//                            .background(
//                                Circle()
//                                    .fill(convertHextoRGB(hexColor: "DB3236"))
//                                    .frame(width: 32, height: 32)
//                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
//                                )
//                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
//                    }
//                }
//            }.onAppear(perform: {
//                if(GIDSignIn.sharedInstance()?.currentUser != nil){
//
//                    // Saved userID if it exists
//                    if self.googleDelegate.userID != "" {
//
//                        // Write user information to cache
//                        let userInformationCoreDataWrite: User = User(context: self.moc)
//                        userInformationCoreDataWrite.id = self.googleDelegate.userID
//                        userInformationCoreDataWrite.email = self.googleDelegate.email
//                        userInformationCoreDataWrite.firstName = self.googleDelegate.firstName
//                        userInformationCoreDataWrite.lastName = self.googleDelegate.lastName
//                        try? self.moc.save()
//
//                        // Write user information to RAM
//                        self.userInformation.id = self.googleDelegate.userID
//                        self.userInformation.email = self.googleDelegate.email
//                        self.userInformation.firstName = self.googleDelegate.firstName
//                        self.userInformation.lastName = self.googleDelegate.lastName
//                        self.userInformation.fullName = self.googleDelegate.firstName + " " + self.googleDelegate.lastName
//
//                        // Load messages
//                        DispatchQueue.main.async {
//                            self.updateMessageHistoryServer(userID: self.googleDelegate.userID)
//                        }
//
//                        self.rootViewIsActive = true
//                    }
//                }
//            })
//            NavigationLink(destination: ChatView(rootViewIsActive: self.$rootViewIsActive).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$rootViewIsActive){EmptyView()}
//                    .isDetailLink(false)
//        }
//    }
//
//    func updateMessageHistoryServer(userID: String) {
//        var messageHistoryData: [[String: String]] = [[String: String]]()
//
//        // Clear message cache
//        for message in MessagesCoreData {
//            moc.delete(message)
//        }
//        try? self.moc.save()
//
//        // Get messages from server
//        messageHistoryData = self.messages.getHistory(userID: userID)
//
//        // Load messages
//        if !messageHistoryData.isEmpty {
//            for message in messageHistoryData {
//                self.loadMessageServer(message: message)
//            }
//        }
//    }
//
//    func loadMessageServer(message: [String: String]) {
//        // Load messages into RAM
//        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
//
//        //  Toggle the user type
//        isCurrentUserLoadServer.toggle()
//    }
//
//}
//
//// PersonalLoginButton (height: 7%)
//struct PersonalLoginButton: View {
//    var width: CGFloat?
//    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var userInformation: UserInformation
//    @EnvironmentObject var googleDelegate: GoogleDelegate
//    @Binding var rootViewIsActive: Bool
//    @Binding var isHiddenLoginView: Bool
//    @Binding var isHiddenSignupView: Bool
//
//    var body: some View {
//        Button(action: {
//            self.isHiddenLoginView = true
//            self.isHiddenSignupView = false
//        }, label: {
//            Image(systemName: "envelope.fill")
//                .font(.system(size: 16))
//                .foregroundColor(Color(UIColor.white))
//                .shadow(color: Color(UIColor.black).opacity(0.32), radius: 6, x: 3, y: 3)
//                .background(
//                    Circle()
//                        .fill(convertHextoRGB(hexColor: "1757A8"))
//                        .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
//                        .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
//                )
//                    .padding(EdgeInsets(top: 0, leading: (width ?? CGFloat(100))*0.04, bottom: 0, trailing: (width ?? CGFloat(100))*0.03))
//        })
//    }
//}
