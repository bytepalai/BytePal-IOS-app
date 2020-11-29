//
//  GoogleLoginButton.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleSignIn

// GoogleLoginButton (height: 7%)
struct GoogleLoginButton: View {
    
    // Arguments
    var width: CGFloat?
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenChatView: Bool
    
    // Core Data
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @Environment(\.managedObjectContext) var moc
    
    // Environment Object
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate

    // States (Bindings)
    @State var isCurrentUserLoadServer = true

    var body: some View {
        VStack {
                
            Button(action: {
                GIDSignIn.sharedInstance().signIn()
            }){
                Text("G")
                    .font(.custom(fontStyle, size: 26))
                    .foregroundColor(Color(UIColor.white))
                    .background(
                        Circle()
                            .fill(convertHextoRGB(hexColor: "DB3236"))
                            .frame(width: CGFloat(36), height: CGFloat(36))
                            .shadow(color: Color(UIColor.black).opacity(0.60), radius: 4, x: 3, y: 3)
                    )
                        .padding([.leading, .trailing], (width ?? CGFloat(100))*0.04)
            }
             .onAppear(perform: {
                if(GIDSignIn.sharedInstance()?.currentUser != nil){
                                        
                    // Saved userID if it exists
                    if self.googleDelegate.userID != "" {
                        
                        // Init IAP
                        IAPManager.shared.initIAP(userID: self.googleDelegate.userID)
                        
                        // Save user information to cache
                        if UserInformationCoreDataRead.count == 0 {
                            // Is not logged in
                            let userInformationCoreDataWrite: User = User(context: self.moc)
                            userInformationCoreDataWrite.id = self.googleDelegate.userID
                            userInformationCoreDataWrite.email = self.googleDelegate.email
                            userInformationCoreDataWrite.givenName = self.googleDelegate.givenName
                            userInformationCoreDataWrite.familyName = self.googleDelegate.familyName
                            DispatchQueue.main.async {
                                try? self.moc.save()
                            }
                        } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                            // Is logged (After termination)
                            
                            for userInformation in UserInformationCoreDataRead {
                                moc.delete(userInformation)
                            }
                            
                            let userInformationCoreDataWrite: User = User(context: self.moc)
                            userInformationCoreDataWrite.id = self.googleDelegate.userID
                            userInformationCoreDataWrite.email = self.googleDelegate.email
                            userInformationCoreDataWrite.givenName = self.googleDelegate.givenName
                            userInformationCoreDataWrite.familyName = self.googleDelegate.familyName
                            DispatchQueue.main.async {
                                try? self.moc.save()
                            }
                            
                            DispatchQueue.main.async {
                                try? self.moc.save()
                            }
                        }
                        
                        // Write user information to RAM
                        self.userInformation.id = self.googleDelegate.userID
                        self.userInformation.email = self.googleDelegate.email
                        self.userInformation.givenName = self.googleDelegate.givenName
                        self.userInformation.familyName = self.googleDelegate.familyName
                        self.userInformation.fullName = self.googleDelegate.givenName + " " + self.googleDelegate.familyName

                        // Load messages
                        DispatchQueue.main.async {
                            self.updateMessageHistoryServer(userID: self.googleDelegate.userID)
                        }

                        self.isHiddenLoginView = true
                        self.isHiddenChatView = false
                    }
                }
            })
        }
    }

    func updateMessageHistoryServer(userID: String) {
        var messageHistoryData: [[String: String]] = [[String: String]]()

        // Clear message cache
        for message in MessagesCoreDataRead {
            moc.delete(message)
        }
        try? self.moc.save()

        // Get messages from server
        messageHistoryData = self.messages.getHistory(userID: userID)

        // Load messages
        if !messageHistoryData.isEmpty {
            for message in messageHistoryData {
                self.loadMessageServer(message: message)
            }
        }
    }

    func loadMessageServer(message: [String: String]) {
        // Load messages into RAM
        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)

        //  Toggle the user type
        isCurrentUserLoadServer.toggle()
    }

}
