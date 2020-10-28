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

class Messages: ObservableObject {
    @Published var list: [[String: Any]] = [[String: Any]]()
    @Published var messagesLeft: Int = -1
    @Published var lastMessages: [String] = [String]()
}

struct MessageHistory: View{
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @ObservedObject private var keyboard = KeyboardResponder()
    @State public var textFieldString: String = ""
    @State public var messageString: String = ""
    @State var TextForMultiLine: String =
        """
        """
    @State var keyboardIsUp: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                // Render message history from bottom to top
                VStack {
                    List {
                        ForEach((0 ..< self.messages.list.count), id: \.self) { i in
                            MessageView(id: self.messages.list[i]["id"] as! UUID, message: MessageInformation(content: self.messages.list[i]["content"] as! String, isCurrentUser: self.messages.list[i]["isCurrentUser"] as! Bool))
                                .rotationEffect(.radians(.pi))
                        }
                    }
                        .rotationEffect(.radians(.pi))
                        .frame(width: geometry.size.width, height: 540, alignment: .bottom)
                }

                // Message Bar
                HStack {
                    GeometryReader { geometry in
                        // Text Box with TTS Button
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)                                          // Text box border
                                .fill(convertHextoRGB(hexColor: "ffffff"))
                                .frame(width: geometry.size.width - 16 , height: 40)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
                            // Text box entry area
                            // Single Line Text Field
                            TextField("Enter text here", text: self.$textFieldString)
                                .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 48))
                        }
                    }
                    // Send message button
                    Button(action: {
                        if !(self.textFieldString.trimmingCharacters(in: .whitespaces).isEmpty) {
                            DispatchQueue.global(qos: .userInitiated).async {   // executing functions in here sends user message first
                                self.sendUserMessage()
                                self.sendChatbotMessage()
                            }
                        }
                    }){
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(convertHextoRGB(hexColor: greenColor))
                            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 6)
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                }
                .frame(width: geometry.size.width, height: 70, alignment: .bottom)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: self.keyboard.currentHeight, trailing: 0))
                .background(Color(UIColor.white).opacity(20))
                
                // Navigation Bar
                NavigationBar()
                    .frame(width: geometry.size.width, height: 80)
            }
        }
    }
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    func sendUserMessage() {
        // Save user message to cache
        let messageListCoreData = Message(context: self.moc)
        messageListCoreData.id = UUID()
        messageListCoreData.content = self.textFieldString
        messageListCoreData.isCurrentUser = true
        try? self.moc.save()
        
        // Update message history with user message
        DispatchQueue.main.async {
            self.messages.list.insert(["id": UUID(), "content": self.textFieldString, "isCurrentUser": true], at: self.messages.list.startIndex)
        }
        
        // Clear message box
        self.messageString = self.textFieldString
        self.textFieldString = ""
    }
    
    func sendChatbotMessage(){
        let messageListCoreData = Message(context: self.moc)
        var message: String = ""
        
        DispatchQueue.main.async {
            MakeRequest.sendMessage(message: self.messageString, userID: self.userInformation.id){
                response1, response2 in
                message = response1
                Sounds.playSounds(soundfile: response2)
               
                //Save bot message to cache
                messageListCoreData.id = UUID()
                messageListCoreData.content = message
                messageListCoreData.isCurrentUser = false
                try? self.moc.save()
                
                self.messages.list.insert(["id": UUID(), "content": message, "isCurrentUser": false], at: self.messages.list.startIndex)
            }
            
        }
    }
}
