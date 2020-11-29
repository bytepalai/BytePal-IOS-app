//
//  MessageHistory.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Speech
import Combine
import CoreData
import GoogleSignIn
import FBSDKLoginKit

struct MessageHistory: View{
    
    // Arguments
    
    let width: CGFloat?
    let height: CGFloat?
    
    //// Control which view is beign shown
    @Binding var isHiddenUserBar: Bool
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenAccountSettingsView: Bool
    
    // Core Data
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    
    // Environment Object
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    
    // Observable Objects
    @ObservedObject var keyboard = KeyboardResponder()
    
    var body: some View {
        ZStack {
            
            // Chat View
            VStack {

                // Message Scroll View (height: 82%)
                MessageScrollView(
                    width: width,
                    height: height
                )
                
                // Message Bar (height: 8%)
                MessageBarView(
                    width: width,
                    height: height
                )
                
                // NavigationBar (height: 10%)
                NavigationBar(
                     width: (width ?? CGFloat(100)),
                    height: (height ?? CGFloat(200))*0.10,
                    isHiddenHomeView: self.$isHiddenHomeView,
                    isHiddenChatView: self.$isHiddenChatView,
                    isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
                )
                    .isHidden(keyboard.isUp, remove: keyboard.isUp)

            }
                .frame(alignment: .bottom)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .isHidden(self.isHiddenChatView, remove: self.isHiddenChatView)
                .onAppear(perform: {
                    print("----- ID (MessageHistory): \(self.userInformation.id)")
                    print("----- messages (MessageHistory): ")
                    print(messages.list)
                    
                })
                

            // Home View
            HomeView(
                width: self.width,
                height: self.height,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenHomeView: self.$isHiddenHomeView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
            )
                .isHidden(self.isHiddenHomeView, remove: self.isHiddenHomeView)
                
            
            // Settings Views
            AccountSettingsView(
                width: self.width,
                height: self.height,
                isHiddenUserBar: self.$isHiddenUserBar,
                isHiddenLoginView: self.$isHiddenLoginView,
                isHiddenHomeView: self.$isHiddenHomeView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
            )
                .isHidden(self.isHiddenAccountSettingsView, remove: self.isHiddenAccountSettingsView)
                
        }
        
    }
    
}

struct MessageHistory_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
