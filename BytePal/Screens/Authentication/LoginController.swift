//
//  LoginController.swift
//  BytePal
//
//  Created by may on 8/4/20.
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
    
    func facebookLogin (id: String, email: String, first_name: String, last_name: String) -> String {
    //      Init
            let semaphore = DispatchSemaphore (value: 0) //Create counter for async management
            var loginStatus: String = ""

    //      Define header of POST Request
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/facebook")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

    //      Define body POST Request
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

    //      Return loginStatus
            return loginStatus
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

    //      Return loginStatus
            return loginStatus
        }
}

class SocialMediaAuth {
    
    // Facebook Single Sign On
    func fbSSO() -> String {
        var id: String = ""
        var email: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var userID: String = ""
        
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
            
            // Handeler FB Login
            
            // Set ID
            id = result!.token!.userID
            
            // Get user profile infromation
            let tokenString: String = result!.token!.tokenString    // Set FBGraphAPI token
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
                }
            })
            userID = BytePalAuth().facebookLogin(id: id, email: email, first_name: firstName, last_name: lastName)
        }
        
        return userID
    }
    
    func fbLogout(){
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
    }
    
    func accountLoggedIn() -> String {
        if(GIDSignIn.sharedInstance()?.currentUser != nil){
            return "Google"
        } else if (AccessToken.current ?? nil) != nil {
            if !AccessToken.current!.isExpired {
                return "Facebook"
            }
        } else {
            return "Personal"
        }
        return ""
    }
}

class FBLogin: ObservableObject {
    @Published var isShowingChatView: Bool = false
}

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    let bytepalAuth: BytePalAuth = BytePalAuth()
    @Published var signedIn: Bool = false
    @Published var userID: String = ""

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
        let idToken: String = user.authentication.idToken
        let email: String = GIDSignIn.sharedInstance().currentUser!.profile.email
        let givenName: String = GIDSignIn.sharedInstance().currentUser!.profile.givenName
        let familyName: String = GIDSignIn.sharedInstance().currentUser!.profile.familyName
        
        let userID: String = bytepalAuth.googleLogin(id: idToken, email: email, first_name: givenName, last_name: familyName)
        
        self.userID = userID
        self.signedIn = true
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
