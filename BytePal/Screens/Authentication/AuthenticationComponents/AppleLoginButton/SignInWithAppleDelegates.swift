//
//  AppleLoginView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import UIKit
import AuthenticationServices
import Contacts

class SignInWithAppleDelegates: NSObject {
//    private let signInSucceeded: (Bool) -> Void
    private let userData: ([String]) -> Void
    private weak var window: UIWindow!
  
    init(window: UIWindow?, data: @escaping([String]) -> Void) {
        self.window = window
        self.userData = data
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
    // 1
    
    let userInformationApple = UserData(email: credential.email!,
                            name: credential.fullName!,
                            identifier: credential.user)
    
    
    var userDataArray: [String] = [String]()
    
    userDataArray.append(String(describing: userInformationApple.email))
    userDataArray.append(String(describing: userInformationApple.name.givenName))
    userDataArray.append(String(describing: userInformationApple.name.familyName))
    userDataArray.append(String(describing: userInformationApple.identifier))
    
    
    // 2
    let keychain = UserDataKeychain()
    do {
        print("----- test 1")
      try keychain.store(userInformationApple)
    } catch {
        print("----- test 2")
        print("------ ERROR: \(error)")
        userDataArray.append("false")
        self.userData(userDataArray)
    }
    

    
    // 3
    do {
        print("----- test 3")
        let success = try WebApi.Register(user: userInformationApple,
                                        identityToken: credential.identityToken,
                                        authorizationCode: credential.authorizationCode)
        
        // Return sign in status and user information
        userDataArray.append("true")
        self.userData(userDataArray)
        
    } catch {
        print("----- test 4")
        userDataArray.append("false")
        self.userData(userDataArray)
    }
    
  }

  private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
    // You *should* have a fully registered account here.  If you get back an error from your server
    // that the account doesn't exist, you can look in the keychain for the credentials and rerun setup

    // if (WebAPI.Login(credential.user, credential.identityToken, credential.authorizationCode)) {
    //   ...
    // }
    var userDataArray: [String] = [String]()
    userDataArray.append("Existing Account")
    userDataArray.append("Existing Account")
    userDataArray.append("Existing Account")
    userDataArray.append("Existing Account")
    userDataArray.append("true")
    self.userData(userDataArray)
  }

  private func signInWithUserAndPassword(credential: ASPasswordCredential) {
    // You *should* have a fully registered account here.  If you get back an error from your server
    // that the account doesn't exist, you can look in the keychain for the credentials and rerun setup

    // if (WebAPI.Login(credential.user, credential.password)) {
    //   ...
    // }
    var userDataArray: [String] = [String]()
    userDataArray.append("User and Password")
    userDataArray.append("User and Password")
    userDataArray.append("User and Password")
    userDataArray.append("User and Password")
    userDataArray.append("true")
    self.userData(userDataArray)
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
        registerNewAccount(credential: appleIdCredential)
      } else {
        signInWithExistingAccount(credential: appleIdCredential)
      }

      break
      
    case let passwordCredential as ASPasswordCredential:
      signInWithUserAndPassword(credential: passwordCredential)

      break
      
    default:
      break
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
  }

    
    func signup (email: String, password: String, firstName: String, lastName: String, completion: @escaping(String) -> Void ) {
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = """
        {
            \"email\": \"\(email)\",
            \"password\": \"\(password)\",
            \"first_name\": \"\(firstName)\",
            \"last_name\": \"\(lastName)\"
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
                    
//                    // Init IAP
//                    IAPManager.shared.initIAP(userID: userID)
//
//                    // Save user information to cache
//                    if UserInformationCoreDataRead.count == 0 {
//                        // Is not logged in
//
//                        let userInformationCoreDataWrite: User = User(context: self.moc)
//                        userInformationCoreDataWrite.id = userID
//                        userInformationCoreDataWrite.email = self.email
//                        userInformationCoreDataWrite.firstName = self.firstName
//                        userInformationCoreDataWrite.lastName = self.lastName
//                        DispatchQueue.main.async {
//                            try? self.moc.save()
//                        }
//                    } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
//                        // Is logged (After termination)
//
//                        for userInformation in UserInformationCoreDataRead {
//                            moc.delete(userInformation)
//                        }
//
//                        let userInformationCoreDataWrite: User = User(context: self.moc)
//                        userInformationCoreDataWrite.id = userID
//                        userInformationCoreDataWrite.email = self.email
//                        userInformationCoreDataWrite.firstName = self.firstName
//                        userInformationCoreDataWrite.lastName = self.lastName
//
//                        DispatchQueue.main.async {
//                            try? self.moc.save()
//                        }
//                    }
//
//                    // Write user information to RAM
//                    DispatchQueue.main.async {
//                        self.userInformation.id = userID
//                        self.userInformation.email = self.email
//                        self.userInformation.firstName = self.firstName
//                        self.userInformation.lastName = self.lastName
//                        self.userInformation.fullName = self.firstName + " " + self.lastName
//                    }

//                    // Create agent
//                    DispatchQueue.main.async {
//                        self.createAgent(id: userID)
//                    }
                    
                }
            } catch {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
//    func createAgent(id: String) {
//
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
//        // promise han dler (completion handler in Apple Dev Doc)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                return
//            }
//            do {
//                // Parse response
//                let dataResponse: String = String(data: data, encoding: .utf8)!
//                if dataResponse != "New Agent created" {
//                    err = 1
//                }
//            }
//            semaphore.signal()
//        }
//        task.resume()
//        semaphore.wait()
//
//        if err == 0 {
//            self.isShowingSignupError = false
//            self.isHiddenLoginView = true
//            self.isHiddenSignupView = true
//            self.isHiddenChatView = false
//        } else {
//            print("------- Agent ALREADY created")
//        }
//    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}
