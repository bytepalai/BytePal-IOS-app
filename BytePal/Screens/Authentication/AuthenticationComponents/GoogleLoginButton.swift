//
//  GoogleLoginButton.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData
import GoogleSignIn

//// GoogleLoginButton (height: 7%)
//struct GoogleLoginButton: View {
//    var width: CGFloat?
//    var container: NSPersistentContainer!
//    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
//    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
//    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var userInformation: UserInformation
//    @EnvironmentObject var googleDelegate: GoogleDelegate
//    @Binding var rootViewIsActive: Bool
//    @State var isShowingChatView = false
//    @State var isCurrentUserLoadServer = true
//
//    var body: some View {
//        VStack {
//            Group {
//                if googleDelegate.signedIn {
//                    Button(action: {
//                        GIDSignIn.sharedInstance().signIn()
//                    }){
//                        Text("G")
//                            .font(.custom(fontStyle, size: 24))
//                            .foregroundColor(Color(UIColor.white))
//                            .background(
//                                Circle()
//                                    .fill(convertHextoRGB(hexColor: "DB3236"))
//                                    .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
//                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
//                            )
//                                .padding([.leading, .trailing], (width ?? CGFloat(100))*0.03)
//                    }
//                } else {
//                    Button(action: {
//                        GIDSignIn.sharedInstance().signIn()
//                    }){
//                        Text("G")
//                            .font(.custom(fontStyle, size: 24))
//                            .foregroundColor(Color(UIColor.white))
//                            .background(
//                                Circle()
//                                    .fill(convertHextoRGB(hexColor: "DB3236"))
//                                    .frame(width: 32, height: 32)
//                                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
//                                )
//                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
//                    }
//                }
//            }.onAppear(perform: {
//                if(GIDSignIn.sharedInstance()?.currentUser != nil){
//
//                    // Saved userID if it exists
//                    if self.googleDelegate.userID != "" {
//
//                        // Write user information to cache
//                        let userInformationCoreDataWrite: User = User(context: self.moc)
//                        userInformationCoreDataWrite.id = self.googleDelegate.userID
//                        userInformationCoreDataWrite.email = self.googleDelegate.email
//                        userInformationCoreDataWrite.firstName = self.googleDelegate.firstName
//                        userInformationCoreDataWrite.lastName = self.googleDelegate.lastName
//                        try? self.moc.save()
//
//                        // Write user information to RAM
//                        self.userInformation.id = self.googleDelegate.userID
//                        self.userInformation.email = self.googleDelegate.email
//                        self.userInformation.firstName = self.googleDelegate.firstName
//                        self.userInformation.lastName = self.googleDelegate.lastName
//                        self.userInformation.fullName = self.googleDelegate.firstName + " " + self.googleDelegate.lastName
//
//                        // Load messages
//                        DispatchQueue.main.async {
//                            self.updateMessageHistoryServer(userID: self.googleDelegate.userID)
//                        }
//
//                        self.rootViewIsActive = true
//                    }
//                }
//            })
//            NavigationLink(destination: ChatView(rootViewIsActive: self.$rootViewIsActive).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$rootViewIsActive){EmptyView()}
//                    .isDetailLink(false)
//        }
//    }
//
//    func updateMessageHistoryServer(userID: String) {
//        var messageHistoryData: [[String: String]] = [[String: String]]()
//
//        // Clear message cache
//        for message in MessagesCoreData {
//            moc.delete(message)
//        }
//        try? self.moc.save()
//
//        // Get messages from server
//        messageHistoryData = self.messages.getHistory(userID: userID)
//
//        // Load messages
//        if !messageHistoryData.isEmpty {
//            for message in messageHistoryData {
//                self.loadMessageServer(message: message)
//            }
//        }
//    }
//
//    func loadMessageServer(message: [String: String]) {
//        // Load messages into RAM
//        self.messages.list.insert(["id": UUID(), "content": message["text"] ?? "Error can't unwrap message text", "isCurrentUser": isCurrentUserLoadServer], at: self.messages.list.startIndex)
//
//        //  Toggle the user type
//        isCurrentUserLoadServer.toggle()
//    }
//
//}
