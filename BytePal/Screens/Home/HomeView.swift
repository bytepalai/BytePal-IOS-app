//
//  Home.swift
//  BytePal
//
//  Created by Scott Hom on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    // Arguments
    
    let width: CGFloat?
    let height: CGFloat?
    
    //// Control which view is being shown
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenAccountSettingsView: Bool
    
    // Environment Object
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    ScrollView {
                        VStack {
                            UpgradeButton(
                                userID: self.userInformation.id,
                                isHiddenLoginView: self.$isHiddenLoginView,
                                isHiddenHomeView: self.$isHiddenHomeView
                            )
                            MessageCellScrollView(
                                isHiddenLoginView: self.$isHiddenLoginView,
                                isHiddenHomeView: self.$isHiddenHomeView,
                                isHiddenChatView: self.$isHiddenChatView
                            )
                        }
                    }
                }
                VStack {
                    Spacer()
                    NavigationBar(
                        width: width!,
                        height: height!*0.10,
                        isHiddenHomeView: self.$isHiddenHomeView,
                        isHiddenChatView: self.$isHiddenChatView,
                        isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
                    )
                    
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        
    }
    
    func updateHomeViewCards(attributes: [String: [String: String]]) -> [String: [String: String]] {
        var mutatedAttributes = attributes
        
        if self.messages.list.count != 0 {
            let lastUserMessageIndex: Int = 1
            let lastChatbotMessageIndex: Int = 0
            let messagesLeft: String = self.messages.getMessagesLeft(userID: self.userInformation.id)
            let lastUserMessage: String = self.messages.list[lastUserMessageIndex]["content"] as? String ?? ""
            let lastChatbotMessage: String = self.messages.list[lastChatbotMessageIndex]["content"] as? String ?? ""
            
            mutatedAttributes["typing"]!["text"] = messagesLeft
            mutatedAttributes["female user"]!["text"] = lastUserMessage
            mutatedAttributes["BytePal"]!["text"] = lastChatbotMessage
        }
        else {
            mutatedAttributes["typing"]!["text"] = self.messages.getMessagesLeft(userID: self.userInformation.id)
            mutatedAttributes["female user"]!["text"] = "No messages sent to BytePal"
            mutatedAttributes["BytePal"]!["text"] = "No messages receviec from BytePal"
        }
        return mutatedAttributes
    }
    
}

struct CompanyLogo: View {
    @EnvironmentObject var deviceInfo: DeviceInfo
    let height: CGFloat = 75
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: height, alignment: .center)
            
            Text("BytePal")
                .fontWeight(.bold)
                .font(Font.system(size: height * 0.75))
                .foregroundColor(.appFontColorBlack)
        }
        .onAppear(perform: {
            self.deviceInfo.setDeviceGroup()
        })
    }
    
}

struct UpgradeButton: View {
    var userID: String?
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenHomeView: Bool
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
//    @State var isShowingIAPView: Bool = false
    @State var messagesLeftAmount: String = ""
    @State var isShowingPurchaseView: Bool = false
    
    
    var body: some View {
        Group {
                HStack {
                    Spacer()
                    VStack {
                        Text("Messages left")
                            .bold()
                        Text(messagesLeftAmount)
                            .bold()
                        Button(action: {
                            self.isShowingPurchaseView.toggle()
                        }) {
                            Text("Upgrade")
                                .font(.title)
                                .foregroundColor(.appGreen)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                        }
                            .sheet(
                                isPresented: self.$isShowingPurchaseView,
                                content: {
                                    PurchaseView(userID: self.userInformation.id)
                                }
                            )
                    }
                        .font(title2Custom)
                        .foregroundColor(.gray)
                    Spacer()
                }
                    .padding()
                    .background(Color.appLightGray)
                    .cornerRadius(10)
                    .shadow(color: .appGreen, radius: 1, x: 0, y: 0)
                    .padding()
            
        }
            .onAppear(perform: {
                print("------ messages left \(self.userID ?? "Error: user ID not set")")
                messagesLeftAmount = self.messages.getMessagesLeft(userID: self.userID ?? "Error: user ID not set")
            })
    }
}

struct MessageCellScrollView: View {
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @State var userCellAppear: Bool = false
    @State var bytePalCellAppear: Bool = false
    @EnvironmentObject var messages: Messages
    
    var body: some View {
        ScrollView {
            VStack {
                if self.messages.list.count != 0 {
                    HomeMessageCell(
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenHomeView: self.$isHiddenHomeView,
                        messageCreator: .user(
                            message: self.messages.list[1]["content"] as! String))
                    HomeMessageCell(
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenHomeView: self.$isHiddenHomeView,
                        messageCreator: .bytePal(
                            message: self.messages.list[0]["content"] as! String))
                } else {
                    HomeMessageCell(
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenHomeView: self.$isHiddenHomeView,
                        messageCreator: .user(message: "No messages sent to BytePal")
                    )
                    HomeMessageCell(
                        isHiddenLoginView: self.$isHiddenLoginView,
                        isHiddenHomeView: self.$isHiddenHomeView,
                        messageCreator: .bytePal(message: "No messages received from BytePal")
                    )
                }
                
            }
        }
    }
}
