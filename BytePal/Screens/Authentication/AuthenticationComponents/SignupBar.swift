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

// SignupBar (height: 40%)
struct SignupBar: View {
    var width: CGFloat?
    var height: CGFloat?
    @Binding var rootViewIsActive: Bool
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenSignupView: Bool

    var body: some View {
        HStack {

            // SignupBar (height: 10%, heighest is TextView)
            Text("Register")
                .font(.custom(fontStyle, size: 20))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: (width ?? CGFloat(100))*0.10))
            FacebookLoginButton(
                width: width,
                rootViewIsActive: self.$rootViewIsActive
            )
            GoogleLoginButton(
                width: width,
                rootViewIsActive: self.$rootViewIsActive
            )
            PersonalLoginButton(
                width: width,
                rootViewIsActive: self.$rootViewIsActive,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenSignupView: self.$isHiddenSignupView
            )
        }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: (height ?? CGFloat(200))*0.30, trailing: 0))
    }
}
