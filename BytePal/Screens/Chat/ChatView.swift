//
//  ChatView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct ChatView: View {
    
    // Arguments
    var width: CGFloat?
    var height: CGFloat?
    
    //// Control which view is being shown
    @Binding var isHiddenLoginView: Bool
    
    // Environment Object
    @EnvironmentObject var userInformation: UserInformation
    
    // States
    
    //// Control which view is bing shwon
    @State private var isHiddenUserBar: Bool = true
    @State private var isHiddenHomeView: Bool = true
    @State private var isHiddenChatView: Bool = false
    @State private var isHiddenAccountSettingsView: Bool = true

    var body: some View {
        GeometryReader{ geometry  in
            VStack{
                // User Bar (height: 6%)
                UserBar(
                    width: geometry.size.width,
                    sideSquareLength: geometry.size.height*0.06
                )
                    .isHidden(self.isHiddenUserBar, remove: self.isHiddenUserBar)
                
                // Space (4%)
                
                // User Bar (height: 90%)
                MessageHistory(
                    width: self.width,
                    height: self.height,
                    isHiddenUserBar: self.$isHiddenUserBar,
                    isHiddenLoginView: self.$isHiddenLoginView,
                    isHiddenHomeView: self.$isHiddenHomeView,
                    isHiddenChatView: self.$isHiddenChatView,
                    isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
                )
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            // Hide navigation bar. The title must be initiated for it to totally dissapear
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }

}
