//
//  FBLoginController.swift
//  BytePal
//
//  Created by may on 8/18/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import FBSDKLoginKit

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
            print("------------------------ USER ID (SM): \(userID)")
        }
        
        return userID
    }
    
    func fbLogout(){
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
    }
}

class FBLogin: ObservableObject {
    @Published var isShowingChatView: Bool = false
}
