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

class AppleLoginDelegateBP: NSObject, ObservableObject {
    // private let signInSucceeded: (Bool) -> Void
    
    private let userData: ([String]) -> Void
    private weak var window: UIWindow!
    
    // Shared data
    let numSharedDataVar: Int = 5
    @Published var email: String = ""
    @Published var givenName: String = ""
    @Published var familyName: String = ""
    @Published var userIdentifier: String = ""
    @Published var signedIn: Bool = false
  
    init(window: UIWindow?, data: @escaping([String]) -> Void) {
        self.window = window
        self.userData = data
  }
}

extension AppleLoginDelegateBP: ASAuthorizationControllerDelegate {
  private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
    // 1
    
    let userInformationApple = UserData(email: credential.email!,
                            name: credential.fullName!,
                            identifier: credential.user)
    
    
    var userDataArray: [String] = [String]()
    
    self.email = String(userInformationApple.email)
    self.givenName = String(userInformationApple.name.givenName!)
    self.familyName = String(userInformationApple.name.familyName!)
    self.userIdentifier = String(userInformationApple.identifier)
    
    // 3
    do {
    
        let success = try WebApi.Register(user: userInformationApple,
                                        identityToken: credential.identityToken,
                                        authorizationCode: credential.authorizationCode)
    
        // Parse sign in status and user information
        if self.email == nil || self.email == "" {
            
            // Not all user information returned from Apple
            userDataArray.append(self.userIdentifier)
            userDataArray.append("true")
    
        } else {
            
            // All user information returned from Apple
            userDataArray.append(self.email)
            userDataArray.append(self.givenName)
            userDataArray.append(self.familyName)
            userDataArray.append(self.userIdentifier)
            userDataArray.append("true")
    
        }

        // Handle sign in status and user information
        self.userData(userDataArray)

    } catch {

        // Error Apple Login or Store to Keychain
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
    
    let identifier: String = credential.user
    
    var userDataArray: [String] = [String]()
    userDataArray.append(identifier)
    userDataArray.append("true")
    self.userData(userDataArray)
  }

  private func signInWithUserAndPassword(credential: ASPasswordCredential) {
    // You *should* have a fully registered account here.  If you get back an error from your server
    // that the account doesn't exist, you can look in the keychain for the credentials and rerun setup

    // if (WebAPI.Login(credential.user, credential.password)) {
    //   ...
    // }
    let identifier: String = credential.user
    
    var userDataArray: [String] = [String]()
    userDataArray.append(identifier)
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

    
}

extension AppleLoginDelegateBP: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}
