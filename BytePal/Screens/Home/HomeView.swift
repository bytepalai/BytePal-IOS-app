//
//  Home.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var number: NumberController = NumberController()
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    
    //  Attributes Cards
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

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    ScrollView {
                        VStack {
                            CompanyLogo()
                            UpgradeButton()
                            MessageCellScrollView()
                        }
                    }
                }
                VStack {
                    Spacer()
                    NavigationBar()
                        .frame(width: geometry.size.width, height: 104)
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @State var isShowingIAPView: Bool = false
    @State var messagesLeftAmount: String = ""
    
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
                            self.isShowingIAPView = true
                        }) {
                            Text("Upgrade")
                                .font(.title)
                                .foregroundColor(.appGreen)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                        }
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
                NavigationLink(
                    destination: IAPView(productsStore: ProductsStore.shared, viewModel: .init()).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages),
                    isActive: self.$isShowingIAPView){EmptyView()}
        }
            .onAppear(perform: {
                messagesLeftAmount = self.messages.getMessagesLeft(userID: self.userInformation.id)
            })
    }
}

struct MessageCellScrollView: View {
    @State var userCellAppear: Bool = false
    @State var bytePalCellAppear: Bool = false
    @EnvironmentObject var messages: Messages
    
    var body: some View {
        ScrollView {
            VStack {
                if self.messages.list.count != 0 {
                    HomeMessageCell(messageCreator: .user(message: self.messages.list[1]["content"] as! String))
                    HomeMessageCell(messageCreator: .bytePal(message: self.messages.list[0]["content"] as! String))
                } else {
                    HomeMessageCell(messageCreator: .user(message: "No messages sent to BytePal"))
                    HomeMessageCell(messageCreator: .bytePal(message: "No messages received from BytePal"))
                }
                
            }
        }
    }
}

//struct HomeView: View {
//    var number: NumberController = NumberController()
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var userInformation: UserInformation
//
//    //  Attributes Cards
//    @State var homeViewCardAttributes: [String: [String: String]] = [
//        "typing":
//                [
//                    "title": "Messages",
//                    "image": "typing",
//                    "text": "",
//                    "buttonText": "Upgrade"
//                ],
//        "female user":
//                [
//                    "title": "Last message sent",
//                    "image": "female user",
//                    "text": "",
//                    "buttonText": "Continue"
//                ],
//        "BytePal":
//                [
//                    "title": "Last message sent by BytePal",
//                    "image": "BytePal",
//                    "text": "",
//                    "buttonText": "Continue"
//                ]
//    ]
//
////    func updateLastMesasge() {
////        let numberMessages: Int = self.messages.list.count
////        self.messages.lastMessages[0] = self.messages.list[numberMessages-2]
////        self.messages.lastMessages[1] = self.messages.list[numberMessages-1]
////    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack {
//                    HStack {
//                        Image("logo")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .fixedSize()
//                        Text("BytePal")
//                            .font(.custom(fontStyle, size: 28))
//                    }
//                        .padding(16)
//                        .zIndex(2)
//                        .opacity(80)
//                    ScrollView {
//                        ForEach((0 ..< homeViewCardType.count), id: \.self) { i in
//                            ButtonCard(
//                                type: homeViewCardType[i],
//                                title: self.homeViewCardAttributes[homeViewCardType[i]]?["title"] ?? "error",
//                                image: self.homeViewCardAttributes[homeViewCardType[i]]?["image"] ?? "error",
//                                text: self.homeViewCardAttributes[homeViewCardType[i]]?["text"] ?? "error",
//                                buttonText: self.homeViewCardAttributes[homeViewCardType[i]]?["buttonText"] ?? "error"
//                            )
//                        }
//                    }
//                        .frame(width: geometry.size.width, height: 640)
//                        .onAppear(perform: {
//                            self.homeViewCardAttributes = self.updateHomeViewCards(attributes: self.homeViewCardAttributes)
//                    })
//                        .zIndex(0)
//                    Spacer(minLength: CGFloat(40))
//                    NavigationBar()
//                        .zIndex(1)
//                    Spacer(minLength: CGFloat(96))
//                }
//            }
//                .navigationBarBackButtonHidden(true)
//        }
//    }
//}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
