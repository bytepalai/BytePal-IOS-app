//
//  SignupBar.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

// SignupBar (height: 40%)
struct SignupBar: View {
    var width: CGFloat?
    var height: CGFloat?
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenSignupView: Bool

    var body: some View {
        HStack {

            // SignupBar (height: 10%, heighest is TextView)
            FacebookLoginButton(
                width: width,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenChatView: self.$isHiddenChatView
            )
            GoogleLoginButton(
                width: width,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenChatView: self.$isHiddenChatView
            )
            PersonalLoginButton(
                width: width,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenSignupView: self.$isHiddenSignupView
            )
            AppleLoginButton()
        }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: (height ?? CGFloat(200))*0.30, trailing: 0))
    }
}
