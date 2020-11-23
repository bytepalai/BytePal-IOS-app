//
//  FacebookLoginButton.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

// FacebookLoginButton (height: 7%)
struct FacebookLoginButton: View {
    var width: CGFloat?
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView = false
    @State var isCurrentUserLoadServer: Bool = true
    @Binding var rootViewIsActive: Bool

    var body: some View {
        Button(action: {
            self.loginFB(completion: { id in

                // Load messages from server
                NetworkStatus.checkNetworkStatus(completion: { netStat in
                    if netStat["status"] == true {
                        DispatchQueue.main.async {
                            // Update messages
                            self.updateMessageHistoryServer(userID: id)
                            self.rootViewIsActive = true
                        }
                    }
                })
            })
        }){
            VStack {
                Text("f")
                    .font(.custom(fontStyle, size: 20))
                    .foregroundColor(Color(UIColor.white))
                    .background(
                        Circle()
                            .fill(convertHextoRGB(hexColor: "3B5998"))
                            .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
                            .shadow(color: Color(UIColor.black).opacity(0.48), radius: 4, x: 3, y: 3)
                    )
                        .padding([.trailing], (width ?? CGFloat(100))*0.05)
                NavigationLink(destination: ChatView(rootViewIsActive: self.$rootViewIsActive).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$rootViewIsActive){EmptyView()}
                        .isDetailLink(false)
            }
        }
    }

    func loginFB(completion: @escaping(String) -> Void) {
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
                            
                            // Check IAP Subscription
                            IAPManager.shared.initIAP(userID: fbUserInformation["id"]!)
                            
                            // Create Agent
                            self.createAgent(id: fbUserInformation["id"]!)

                            // Save user information to cache
                            if UserInformationCoreDataRead.count == 0 {
                                // Is not logged in
                                
                                let userInformationCoreDataWrite: User = User(context: self.moc)
                                userInformationCoreDataWrite.id = fbUserInformation["id"]!
                                userInformationCoreDataWrite.email = fbUserInformation["email"]!
                                userInformationCoreDataWrite.firstName = fbUserInformation["firstName"]!
                                userInformationCoreDataWrite.lastName = fbUserInformation["lastName"]!
                                DispatchQueue.main.async {
                                    try? self.moc.save()
                                }
                            } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                                // Is logged (After termination)
                                
                                for userInformation in UserInformationCoreDataRead {
                                    moc.delete(userInformation)
                                }
                                
                                let userInformationCoreDataWrite: User = User(context: self.moc)
                                userInformationCoreDataWrite.id = fbUserInformation["id"]!
                                userInformationCoreDataWrite.email = fbUserInformation["email"]!
                                userInformationCoreDataWrite.firstName = fbUserInformation["firstName"]!
                                userInformationCoreDataWrite.lastName = fbUserInformation["lastName"]!
                                
                                DispatchQueue.main.async {
                                    try? self.moc.save()
                                }
                            }
                            
                            

                            // Write user information to RAM
                            self.userInformation.id = fbUserInformation["id"]!
                            self.userInformation.email = fbUserInformation["email"]!
                            self.userInformation.firstName = fbUserInformation["firstName"]!
                            self.userInformation.lastName = fbUserInformation["lastName"]!
                            self.userInformation.fullName = fbUserInformation["firstName"]! + " " + fbUserInformation["lastName"]!

                            completion(fbUserInformation["id"]!)
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
            self.rootViewIsActive = true
        } else {
            print("Agent ALREADY created")
        }
    }

    func updateMessageHistoryServer(userID: String) {
        var messageHistoryData: [[String: String]] = [[String: String]]()

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
