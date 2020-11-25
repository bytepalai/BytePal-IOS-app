//
//  LoginController.swift
//  BytePal
//
//  Created by Scott Hom on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI
import FBSDKLoginKit
import GoogleSignIn

class BytePalAuth {
    func personalLogin (email: String, password: String) -> String {
//      Init
        let semaphore = DispatchSemaphore (value: 0) //Create counter for async management
        var loginStatus: String = ""

//      Define header of POST Request
        var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/login")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
//      Define body POST Request
        let parameters = "{  \n   \"email\":\"\(email)\",\n   \"password\":\"\(password)\"\n}"
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData
        
        // Define JSON response format
        struct responseStruct: Decodable {
            var user_id: String
        }
        
//      Create Post Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          Handle Response
            guard let data = data else {
                print(String(describing: error))
                loginStatus = ""
                return
            }
            do {
                if String(data: data, encoding: .utf8)! == "Wrong Password" {
                    loginStatus = "Wrong email or password"
                } else {
                    // Set user_id
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let user_id: String = reponseObject.user_id
                    loginStatus = user_id
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
//      Return loginStatus
        return loginStatus
    }
    
    func facebookLogin (id: String, email: String, first_name: String, last_name: String) -> [String: String] {
        
            // Init
            let semaphore = DispatchSemaphore (value: 0) //Create counter for async management
            var loginStatus: String = ""
            var userInformation: [String: String] = [String: String]()
        
            // Set email and name
            userInformation["email"] = email
            userInformation["firstName"] = first_name
            userInformation["lastName"] = last_name

            // Define header of POST Request
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/facebook")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

            // Define body POST Request
            let parameters = """
            {
                \"id\": \"\(id)\",
                \"email\": \"\(email)\",
                \"first_name\": \"\(first_name)\",
                \"last_name\": \"\(last_name)\"
            }
            """

            let postData = parameters.data(using: .utf8)
            request.httpBody = postData

            // Define JSON response format
            struct responseStruct: Decodable {
                var user_id: String
            }

            // Create Post Request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle Response
                guard let data = data else {
                    print(String(describing: error))
                    loginStatus = ""
                    return
                }
                do {
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let user_id: String = reponseObject.user_id
                    loginStatus = user_id
                } catch {
                    print(error)
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        
            // Set BytePal User ID
            userInformation["id"] = loginStatus
        
            // Return loginStatus
            return userInformation
    }
    
    func googleLogin (id: String, email: String, first_name: String, last_name: String) -> String {
    //      Init
            let semaphore = DispatchSemaphore (value: 0) //Create counter for async management
            var loginStatus: String = ""

    //      Define header of POST Request
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/google")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

    //      Define body POST Request
        
            let parameters = """
            {
                \"idToken\": \"\(id)\",
                \"email\": \"\(email)\",
                \"givenName\": \"\(first_name)\",
                \"familyName\": \"\(last_name)\"
            }
            """
            
            let postData = parameters.data(using: .utf8)
            request.httpBody = postData

            // Define JSON response format
            struct responseStruct: Decodable {
                var user_id: String
            }
        
    //      Create Post Request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //          Handle Response
                guard let data = data else {
                    print(String(describing: error))
                    loginStatus = ""
                    return
                }
                do {
                    let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                    let user_id: String = reponseObject.user_id
                    loginStatus = user_id
                } catch {
                    print(error)
                }
                semaphore.signal()
            }
        
            task.resume()
            semaphore.wait()

            // Pass loginStatus to handler
            return loginStatus
        }
}

class SocialMediaAuth {
    func fbLogout() {
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
    }
    
    func GoogleLogout() {
        print("--------- sign out Google")
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func personalLogout() {
        print("------ Personal Logout")
    }
    
    func logout(personalLoginStatus: Bool) {
        let account: String = self.getAccountLoginStatus(personalLoginStatus: personalLoginStatus)
        switch account {
            case "Facebook":
                print("----- Logged out of Facebook")
                self.fbLogout()
            case "Google":
                print("----- Logged out of Google")
                self.GoogleLogout()
            case "Personal":
                print("----- Logged out of Personal")
                self.personalLogout()
            default:
                print("----- Error: Account did not logout succesfully")
        }
    }
    
    func getAccountLoginStatus(personalLoginStatus: Bool) -> String {
        
        if(GIDSignIn.sharedInstance()?.currentUser != nil){
            print("---- Google")
            return "Google"
        } else if (AccessToken.current ?? nil) != nil {
            if !AccessToken.current!.isExpired {
                print("---- Facebook")
                return "Facebook"
            }
        } else if personalLoginStatus {
            print("---- Personal")
            return "Personal"
        } else {
            print("---- Error 1")
            return "logged out"
        }
        print("---- Error 2")
        return "logged out"
    }
}

class FBLogin: ObservableObject {
    @Published var isShowingChatView: Bool = false
}

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    let bytepalAuth: BytePalAuth = BytePalAuth()
    @Published var userID: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var signedIn: Bool = false

    // Signin Handeler
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)  {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        let clientID: String =  user.authentication.clientID
        let email: String = GIDSignIn.sharedInstance().currentUser!.profile.email
        let givenName: String = GIDSignIn.sharedInstance().currentUser!.profile.givenName
        let familyName: String = GIDSignIn.sharedInstance().currentUser!.profile.familyName
        
        let userID: String = bytepalAuth.googleLogin(
                                id: clientID,
                                email: email,
                                first_name: givenName,
                                last_name: familyName
                            )
        
        if clientID != "" {
            // Save user metadata
            self.userID = userID
            self.email = email
            self.firstName = givenName
            self.lastName = familyName
            self.signedIn = true
        }
    }
    
    //Create Agent Handeler
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
            self.signedIn = true
        } else {
            print("------- Agent ALREADY created")
        }
    }
    
    // Signout Handeler
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        self.signedIn = false
    }
}
