//
//  AppleLoginView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData
import AuthenticationServices

struct AppleLoginButton: View {
    
    // Argument
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenSignupView: Bool
    @Binding var isHiddenChatView: Bool
    
    // Self define object
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()

    // Core Data
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    
    // Environment Object
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @Environment(\.window) var window: UIWindow?
    
    
    // States
    @State private var appleSignInDelegates: AppleLoginDelegateBP! = nil
    @State var isCurrentUserLoadServer: Bool = true

    var body: some View {

        Button(action: {
            
            showAppleLogin()
    
        }, label: {
            Image("White Logo Square")
                .frame(width: CGFloat(37), height: CGFloat(37))
                .clipShape(Circle())
                .shadow(color: Color(UIColor.black).opacity(0.80), radius: 4, x: 2, y: 2)
        })
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                self.performExistingAccountSetupFlows()
            }

    }
    
    private func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        performSignIn(using: [request])
    }

    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    private func performExistingAccountSetupFlows() {
        
        
        print("---- account already exists!")
        
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]

        performSignIn(using: requests)
    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {

        appleSignInDelegates = AppleLoginDelegateBP(window: window) { data in
            
            // Prase user information and sign in state
            let userInformationAppleSignIn: [String: String] = self.getUserInformationAppleSignIn(data: data)

            // Signup
            self.signupAppleLogin(userInformationAppleSignIn: userInformationAppleSignIn)
            
        }

        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }
    
    private func getUserInformationAppleSignIn(data: [String]) -> [String: String] {
        
        var userInformationAppleSignIn: [String: String] = [String: String]()
        
        if data.count == 2 {
            
            // Not all user information was returned
            userInformationAppleSignIn["userIdentifier"] = data[0]
            
        } else if data.count > 2 {
            
            // All user information was returned
            userInformationAppleSignIn["email"] = data[0]
            userInformationAppleSignIn["givenName"] = data[1]
            userInformationAppleSignIn["familyName"] = data[2]
            userInformationAppleSignIn["userIdentifier"] = data[3]
            userInformationAppleSignIn["isSignedIn"] = data[4]
            
        } else {

            print("Error: the user infomration from Apple Server has nothing inside.")
            print("data length: \(data.count)")
            print(data)
            
        }
        
        return userInformationAppleSignIn
        
    }
    
    
    private func signupAppleLogin (userInformationAppleSignIn: [String: String]) {
        
        let lengthUserInformaton: Int = userInformationAppleSignIn.count
        let isSignedIn: String = userInformationAppleSignIn["isSignedIn"]
                                    ?? "Error: signed in state not returned"
        
        if isSignedIn == "true" &&  lengthUserInformaton > 2 {
            
            self.signupAppleLoginAllInformation(
                email: userInformationAppleSignIn["email"]
                            ?? "Error: email not returned from Apple Server",
                givenName: userInformationAppleSignIn["givenName"]
                            ?? "Error: given name not returned from Apple Server",
                familyName: userInformationAppleSignIn["familyName"]
                            ?? "Error: family name not returned from Apple Server",
                userIdentifier: userInformationAppleSignIn["userIdentifier"]
                            ?? "Error: user identifier not returned from Apple Server"
            )
            
        } else if isSignedIn == "true" &&  lengthUserInformaton == 2 {

            self.signupAppleLoginOnlyIdentifier(
                userIdentifier: userInformationAppleSignIn["userIdentifier"]
                            ?? "Error: user identifier not returned from Apple Login"
            )
            
        } else if lengthUserInformaton == 1 {
            
            // Exisiting user signin
            self.signupAppleLoginOnlyIdentifier(
                userIdentifier: userInformationAppleSignIn["userIdentifier"]
                            ?? "Error: user identifier not returned from Apple Login"
            )
            
            
        } else if isSignedIn == "false" &&  lengthUserInformaton == 2 {
            
            print("Unsuccessful sign in")

        } else {
            
            print("Error: uncaught exception. class: AppleLoginButtonView(). func: signupAppleLogin()")
            
        }
        
    }
    
    private func loadMessageHistoryCache(message: Message) {
        
        if message.id != nil {
            self.messages.list.insert(["id": message.id!, "content": message.content!, "isCurrentUser": message.isCurrentUser], at: self.messages.list.startIndex)
        } else {
            print("Error: Unable to unwrap message ID. message = \(message) for /BytePal/Screens/Authentication/LoginView.swift")
        }
        
    }
    
    private func updateMessageHistoryServer(userID: String) {
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
    
    private func loadMessageServer(message: [String: String]) {
        // Load messages into RAM
        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
        
        //  Toggle the user type
        isCurrentUserLoadServer.toggle()
    }
    
    private func signupAppleLoginAllInformation (email: String, givenName: String, familyName: String, userIdentifier: String) {
        
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = """
        {
            \"email\": \"\(email)\",
            \"givenName\": \"\(givenName)\",
            \"familyName\": \"\(familyName)\",
            \"userIdentifier\": \"\(userIdentifier)\"
        }
        """
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/appleSignIn")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
    
        struct responseStruct: Decodable {
            var user_id: String
        }
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                if String(data: data, encoding: .utf8)! == "User Email already Exist" {
                    print("---- Error email already exists")
                } else {
                    // Set user id
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let userID: String = reponseObject.user_id
                    
                    print("----- userID (signup): \(userID)")
                    
                    // Init IAP
                    IAPManager.shared.initIAP(userID: userID)

                    // Save user information to cache
                    if UserInformationCoreDataRead.count == 0 {
                        // Is not logged in

                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = email
                        userInformationCoreDataWrite.givenName = givenName
                        userInformationCoreDataWrite.familyName = familyName
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                        // Is logged (After termination)

                        for userInformation in UserInformationCoreDataRead {
                            moc.delete(userInformation)
                        }

                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = email
                        userInformationCoreDataWrite.givenName = givenName
                        userInformationCoreDataWrite.familyName = familyName

                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    }
                    
                    
                    

                    // Write user information to RAM
                    DispatchQueue.main.async {
                        self.userInformation.id = userID
                        self.userInformation.email = email
                        self.userInformation.givenName = givenName
                        self.userInformation.familyName = familyName
                        self.userInformation.fullName = givenName + " " + familyName
                    }
                    
                    // Write messages to RAM from server.
                    NetworkStatus.checkNetworkStatus(completion: { netStat in
                        
                        if netStat["status"] == true {
                            print("Loading messages from server ...")
                            
                            DispatchQueue.main.async {
                                
                                // Update messages
                                self.updateMessageHistoryServer(userID: userID)
                                
                            }
                            
                        }
                        
                    })
                    
                    // Go to chat view
                    self.isHiddenLoginView = true
                    self.isHiddenSignupView = true
                    self.isHiddenChatView = false

                    // Create agent
                    DispatchQueue.main.async {
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
    
    private func signupAppleLoginOnlyIdentifier (userIdentifier: String) {
        
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = """
        {
            \"userIdentifier\": \"\(userIdentifier)\"
        }
        """
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/appleSignIn")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
    
        struct responseStruct: Decodable {
            var user_id: String
        }
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                if String(data: data, encoding: .utf8)! == "User Email already Exist" {
                    print("---- Error email already exists")
                } else {
                    // Set user id
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let userID: String = reponseObject.user_id
                    
                    print("----- userID (signup): \(userID)")
                    
                    // Init IAP
                    IAPManager.shared.initIAP(userID: userID)

                    // Save user information to cache
                    if UserInformationCoreDataRead.count == 0 {
                        // Is not logged in

                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                        // Is logged (After termination)

                        for userInformation in UserInformationCoreDataRead {
                            moc.delete(userInformation)
                        }

                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID

                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    }

                    // Write user information to RAM
                    DispatchQueue.main.async {
                        self.userInformation.id = userID
                        self.userInformation.email = "Email hidden for privacy."
                    }
                    
                    // Write messages to RAM from server.
                    NetworkStatus.checkNetworkStatus(completion: { netStat in
                        
                        if netStat["status"] == true {
                            print("Loading messages from server ...")
                            
                            DispatchQueue.main.async {
                                
                                // Update messages
                                self.updateMessageHistoryServer(userID: userID)
                                
                            }
                            
                        }
                        
                    })
                    
                    // Go to chat view
                    self.isHiddenLoginView = true
                    self.isHiddenSignupView = true
                    self.isHiddenChatView = false

                    // Create agent
                    DispatchQueue.main.async {
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
    
    private func createAgent(id: String) {

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

        // promise han dler (completion handler in Apple Dev Doc)
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
            self.isHiddenLoginView = true
            self.isHiddenSignupView = true
            self.isHiddenChatView = false
        } else {
            print("------- Agent ALREADY created")
            self.isHiddenLoginView = true
            self.isHiddenSignupView = true
            self.isHiddenChatView = false
        }
        
    }


}
