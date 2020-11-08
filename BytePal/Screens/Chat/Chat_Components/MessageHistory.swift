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
    let width: CGFloat?
    let height: CGFloat?
    @Binding var rootViewIsActive: Bool
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreData: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @ObservedObject private var keyboard = KeyboardResponder()
//    @ObservedObject var productStore: ProductsStore = ProductsStore()
    @ObservedObject var iapViewModel: IAPViewModel = IAPViewModel()
    @State var tempUserID: String = ""
    @State public var textFieldString: String = ""
    @State public var messageString: String = ""
    @State var TextForMultiLine: String =
        """
        """
    @State var keyboardIsUp: Bool = false
    @State var keyboardHeight: CGFloat = CGFloat(0)
    @State var isHiddenHomeView: Bool = true
    @State var isHiddenIAPView: Bool = true
    @State var isHiddenIAPFunctionalView: Bool = true
    @State var isHiddenChatView: Bool = false
    @State var isHiddenAccountSettingsView: Bool = true
    
    // HomeView
    var number: NumberController = NumberController()
    @State var homeViewCardAttributes: [String: [String: String]] = [
        "typing":
                [
                    "title": "",
                    "image": "typing",
                    "text": "",
                    "buttonText": "Upgrade"
                ],
        "female user":
                [
                    "title": "Last message sent",
                    "image": "female user",
                    "text": "",
                    "buttonText": "Continue"
                ],
        "BytePal":
                [
                    "title": "Last message sent by BytePal",
                    "image": "BytePal",
                    "text": "",
                    "buttonText": "Continue"
                ]
    ]
    

    var body: some View {
        VStack{

            // Render messages
            ScrollView {
                ForEach((0 ..< self.messages.list.count), id: \.self) { i in
                    MessageView(id: self.messages.list[i]["id"] as! UUID, message: MessageInformation(content: self.messages.list[i]["content"] as! String, isCurrentUser: self.messages.list[i]["isCurrentUser"] as! Bool))
                        .rotationEffect(.radians(.pi))
                }
            }
                .frame(width: (width ?? CGFloat(100)), height: (height ?? CGFloat(200))*0.72 - keyboard.currentHeight)
                .rotationEffect(.radians(.pi))
                .onAppear {

                    UITableView.appearance().separatorStyle = .none
                    
                    if #available(iOS 14.0, *) {
                        // iOS 14 doesn't have extra separators below the list by default.
                    } else {
                        // To remove only extra separators below the list:
                        UITableView.appearance().tableFooterView = UIView()
                    }

                    // To remove all separators including the actual ones:
                    UITableView.appearance().separatorStyle = .none
                    
                }
                .onTapGesture(perform: {
                    if self.keyboard.isUp {
                        self.keyboard.keyBoardWillHide(notification: Notification(name: Notification.Name(rawValue: "keyboardWillHide")))
                        UIApplication.shared.endEditing()
                    }
                })
            
            // Message bar
            DividerCustom(color: Color(UIColor.systemGray3), length: Float(width ?? CGFloat(100)), width: 1)
                .shadow(color: Color(UIColor.systemGray4), radius: 1, x: 0, y: -1)

            // NavigationBar (height: 8%)
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
                .padding([.bottom], (height ?? CGFloat(200))*0.06 + keyboard.currentHeight)
            
            // NavigationBar (height: 10%)
            NavigationBar(
                width: (width ?? CGFloat(100)),
                height: (height ?? CGFloat(200))*0.10,
                color: Color(UIColor.systemGray3),
                rootViewIsActive: self.$rootViewIsActive,
                isHiddenHomeView: self.$isHiddenHomeView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
            )
            
        }
            .frame(alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                // Fix, dissapearing id in env obj userInformation
                self.tempUserID = self.userInformation.id
            })
            .isHidden(self.isHiddenChatView, remove: self.isHiddenChatView)
        
        // Home
        HomeView(
            width: self.width,
            height: self.height,
            rootViewIsActive: self.$rootViewIsActive,
            isHiddenHomeView: self.$isHiddenHomeView,
            isHiddenIAPView: self.$isHiddenIAPView,
            isHiddenChatView: self.$isHiddenChatView,
            isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
        )
            .isHidden(self.isHiddenHomeView, remove: self.isHiddenHomeView)
        
        // IAP
        IAPView(
            rootViewIsActive: self.$rootViewIsActive,
            isHiddenHomeView: self.$isHiddenHomeView,
            isHiddenIAPView: self.$isHiddenIAPView,
            viewModel: .init()
        )
            .isHidden(self.isHiddenIAPView, remove: self.isHiddenIAPView)
        
        // IAP Functional
//        IAPViewFunctional()
        
        // Settings
        AccountSettingsView(
            width: self.width!,
            height: self.height!,
            rootViewIsActive: self.$rootViewIsActive,
            isHiddenHomeView: self.$isHiddenHomeView,
            isHiddenChatView: self.$isHiddenChatView,
            isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
        )
            .isHidden(self.isHiddenAccountSettingsView, remove: self.isHiddenAccountSettingsView)
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
                print("----- string: \(self.textFieldString)")
                if self.messages.list.count > 0 {
                    print("----- mesage: \(self.messages.list[0])")
                }
                
                self.messages.list.insert(["id": UUID(), "content": self.textFieldString, "isCurrentUser": true], at: self.messages.list.startIndex)
                print("----- string: \(self.textFieldString)")
                if self.messages.list.count > 0 {
                    print("----- mesage: \(self.messages.list[0])")
                }
                self.textFieldString = ""
            }
        } else {
            print("Error: User message is blank")
        }

        // Clear message box
        self.messageString = self.textFieldString
        
    }
    
    func sendChatbotMessage(){
        let messageListCoreData = Message(context: self.moc)
        var message: String = ""
        
        MakeRequest.sendMessage(message: self.messageString, userID: self.tempUserID){
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

struct MessageHistory_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
