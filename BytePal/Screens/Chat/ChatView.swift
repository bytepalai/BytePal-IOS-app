//
//  ChatView.swift
//  SwiftUIChatMessage
//
//  Created by may on 6/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.

import Foundation
import SwiftUI
import Speech
import Combine
import CoreData
import GoogleSignIn
import FBSDKLoginKit

//  Message Meta Data
struct MessageInformation {
    var content: String
    var isCurrentUser: Bool
}

//  Message View
struct MessageView: View, Identifiable {
    var id: UUID
    var message: MessageInformation
    var body: some View {
        HStack (alignment: .bottom, spacing: 16) {
            if message.isCurrentUser == true { Spacer() }
            MessageBubble(message: message.content, isCurrentUser: message.isCurrentUser)
                .padding(
                    message.isCurrentUser ?
                    EdgeInsets(top: 8, leading: 40, bottom: 8, trailing: 8) :
                    EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 40)
                )
            if message.isCurrentUser == false {Spacer() }
        }
    }
}

// Message bubble
struct MessageBubble: View {
    var message: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(message)
            .padding(12)
            .background(isCurrentUser ? convertHextoRGB(hexColor: greenColor) : convertHextoRGB(hexColor: "ccd6d3"))
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .cornerRadius(15)
            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 3, x: 3, y: 7)
    }
}

//  User Inforamtion Bar (Top)
struct UserBar: View{
    var body: some View {
        GeometryReader { geometry in
            VStack(){
                Image("logo")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.16), radius: 2, x: 2, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
            }
            .frame(width: geometry.size.width, height: 48)
        }
    }
}

// Use this for mainting message history between views
class UserInformation: ObservableObject {
    @Published var id: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var messagesLeft: Int = 0
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
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    func sendUserMessage() {
//      Save user message to cache
        let messageListCoreData = Message(context: self.moc)
        messageListCoreData.id = UUID()
        messageListCoreData.content = self.textFieldString
        messageListCoreData.isCurrentUser = true
        try? self.moc.save()
        
//      Update message history with user message
        DispatchQueue.main.async {
            self.messages.list.insert(["id": UUID(), "content": self.textFieldString, "isCurrentUser": true], at: self.messages.list.startIndex)
            //      Clear message box
            self.messageString = self.textFieldString
            self.textFieldString = ""
        }
    }
    
    func sendChatbotMessage(){
        let messageListCoreData = Message(context: self.moc)
        let message: String = sendMessage(message: self.messageString) // Interact with API
        
//      Save bot message to cache
        messageListCoreData.id = UUID()
        messageListCoreData.content = message
        messageListCoreData.isCurrentUser = false
        try? self.moc.save()
        
//      Update message history with bot message
        DispatchQueue.main.async {
            self.messages.list.insert(["id": UUID(), "content": message, "isCurrentUser": false], at: self.messages.list.startIndex)
        }
        
//      Speak bot response
        Chat().speak(message: message)
    }
    
    func sendMessage(message: String) -> String{
        var responseFromChatBot: String?
        let semaphore = DispatchSemaphore (value: 0)

//      Define header of POST Request
        var request = URLRequest(url: URL(string: "\(TEST_SERVER_API_HOSTNAME)/interact")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
//      Define body of POST Request
        let parameters = """
        {
        \"user_id\": \"\(self.userInformation.id)\",
            \"text\" : "\(message)\",
            \"type\" : \"user\"
        }
        """
        let dataPOST = parameters.data(using: .utf8)
        request.httpBody = dataPOST
        
        
        
//      Define JSON response format
        struct responseStruct: Decodable {
            var type: String
            var user_id: String
            var text: String
        }

//      Create POST Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          Handle response
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                let responseData: String = reponseObject.text
                responseFromChatBot = responseData.trimmingCharacters(in: .whitespacesAndNewlines)
            } catch {
                print(error)
            }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
//      Return message from Chatbot
        return responseFromChatBot!
    }

    var body: some View {
        GeometryReader { geometry in
            VStack{
                
//              Render message history from bottom to top
                List {
                    ForEach((0 ..< self.messages.list.count), id: \.self) { i in
                        MessageView(id: self.messages.list[i]["id"] as! UUID, message: MessageInformation(content: self.messages.list[i]["content"] as! String, isCurrentUser: self.messages.list[i]["isCurrentUser"] as! Bool))
                            .rotationEffect(.radians(.pi))
                    }
                }
                    .rotationEffect(.radians(.pi))
//                    .scaleEffect(x: -1, y: 1, anchor: .center)
                    .frame(width: geometry.size.width, height: 510, alignment: .bottom)
                
//              Message Bar
                HStack {
                    GeometryReader { geometry in
//                      Text Box with TTS Button
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)                                          // Text box border
                                .fill(convertHextoRGB(hexColor: "ffffff"))
                                .frame(width: geometry.size.width - 16 , height: 40)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
                            // Text box entry area
//                          Single Line Text Field
                            TextField("Enter text here", text: self.$textFieldString)
                                .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 48))
                        }
                    }
//                  Send message button
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
                
//              Navigation Bar
                NavigationBar()
                    .frame(width: geometry.size.width, height: 80)
            }.onAppear(perform: {
                // Load User ID from Cache to RAM
                for userInfo in self.UserInformationCoreData {
                    self.userInformation.id = userInfo.id!
                }
            })
        }
    }
}

struct ChatView: View {
    var body: some View {
        GeometryReader{ geometry  in
            VStack{
                UserBar()
                VStack {
                    MessageHistory()
                        .edgesIgnoringSafeArea(.bottom)
                }
                .frame(width: geometry.size.width, height: 700)
            }
                
        }
            .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
#endif
