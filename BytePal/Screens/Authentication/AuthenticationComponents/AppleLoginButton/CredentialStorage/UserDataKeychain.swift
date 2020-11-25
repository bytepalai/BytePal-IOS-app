//
//  AppleLoginView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

struct UserDataKeychain: Keychain {
  // Make sure the account name doesn't match the bundle identifier!
  var account = "com.raywenderlich.SignInWithApple.Details"
  var service = "userIdentifier"

  typealias DataType = UserData
}
