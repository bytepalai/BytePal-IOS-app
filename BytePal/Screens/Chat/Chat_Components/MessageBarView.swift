//
//  MessageBarView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData

struct MessageBarView: View {
    
    // Arguments
    var width: CGFloat?
    var height: CGFloat?
    
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
    
    // States
    @State public var textFieldString: String = ""
    @State public var messageString: String = ""

    var body: some View {
        
        DividerCustom(color: Color(UIColor.systemGray3), length: Float(width ?? CGFloat(100)), width: 1)
            .shadow(color: Color(UIColor.systemGray4), radius: 1, x: 0, y: -1)
        
        // Message bar
        HStack {
            // Text field
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)                           // Text box border
                    .fill(Color(UIColor.white))
                    .frame(width: (width ?? CGFloat(66)) - 66 , height: 40)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
                // Text box entry area
                // Single Line Text Field
                TextField("Enter text here", text: self.$textFieldString)
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 48))
            }
                .padding([.top], 16)
            
            // Send button
            Button(action: {
                if !(self.textFieldString.trimmingCharacters(in: .whitespaces).isEmpty) {
                    
                    // Send message
                    DispatchQueue.global(qos: .userInitiated).async {
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
                .padding(EdgeInsets(top: 16, leading: 4, bottom: 0, trailing: 16))
            
        }
            .frame(
                width: width,
                height: (height ?? CGFloat(200))*0.02,
                alignment: .top
            )
            .padding([.bottom], keyboard.isUp ? 0 : (height ?? CGFloat(200))*0.06)
        
    }
    
    func sendUserMessage() {
        // Save user information and message to cache
        let messageListCoreData = Message(context: self.moc)
        messageListCoreData.id = UUID()
        messageListCoreData.isCurrentUser = true
        messageListCoreData.content = self.textFieldString
        try? self.moc.save()
        
        if textFieldString != "" {
            // Update message history with user message
            DispatchQueue.main.async {
                
                // Store message in RAM
                self.messages.list.insert(["id": UUID(), "content": self.textFieldString, "isCurrentUser": true], at: self.messages.list.startIndex)
                
                // Store in temporary variable
                self.messageString = self.textFieldString
                
            }
            
        } else {
            print("Error: User message is blank")
        }

    }
    
    func sendChatbotMessage(){
        let messageListCoreData = Message(context: self.moc)
        var message: String = ""
        
        MakeRequest.sendMessage(message: self.messageString, userID: self.userInformation.id){
            response1, response2 in
            
            message = response1
            Sounds.playSounds(soundfile: response2)
            
            //Save bot message to cache
            messageListCoreData.id = UUID()
            messageListCoreData.content = message
            messageListCoreData.isCurrentUser = false
            try? self.moc.save()
            
            DispatchQueue.main.async {
                self.messages.list.insert(["id": UUID(), "content": message, "isCurrentUser": false], at: self.messages.list.startIndex)
            }
        }
    }
}
