//
//  AppleLoginView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import UIKit
import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    @Environment(\.window) var window: UIWindow?
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil

    var body: some View {

        Button(action: {
            print ("----- button 1")
            showAppleLogin()
            print ("----- button 2")
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
        print("----- show 1")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        print("----- show 2")
        request.requestedScopes = [.fullName, .email]
        
        print("----- show 3")
        performSignIn(using: [request])
    }

    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    private func performExistingAccountSetupFlows() {
        #if !targetEnvironment(simulator)
        // Note that this won't do anything in the simulator.  You need to
        // be on a real device or you'll just get a failure from the call.
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]

        performSignIn(using: requests)
        #endif
    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        print("---- perform 1")
        appleSignInDelegates = SignInWithAppleDelegates(window: window) { data in
            print("---- perform 2")
            if data[data.count - 1] == "true" {
                
                print("--------------- login results:")
                
                for info in data {
                    print(info)
                }
                
            } else {
                // show the user an error
            }
        }

        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates

        controller.performRequests()
    }
}
