//
//  Home.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                CompanyLogo()
                    .padding([.top,.bottom], 75)
                UpgradeButton()
                MessageCellScrollView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct CompanyLogo: View {
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
    }
    
    //MARK: Constant
    let height: CGFloat = 75
}

struct UpgradeButton: View {
    var body: some View {
        NavigationLink(
            destination: Text("Destination"),
            label: {
                HStack {
                    Spacer()
                    if #available(iOS 14.0, *) {
                        VStack {
                            Text("Messages left")
                                .bold()
                            Text("5181 | 1000")
                                .bold()
                            Text("Upgrade")
                                .font(.title)
                                .foregroundColor(.appGreen)
                                .fontWeight(.bold)
                        }
                        .font(.title2)
                        .foregroundColor(.gray)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.appLightGray)
                .cornerRadius(10)
                .shadow(color: .appGreen, radius: 1, x: 0, y: 0)
                .padding()
            })
    }
}

struct MessageCellScrollView: View {
    @State var userCellAppear: Bool = false
    @State var bytePalCellAppear: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                if userCellAppear {
                    HomeMessageCell(messageCreator: .user(message: "My favorite food is fasta, what is yours ?"))
                }
                if bytePalCellAppear {
                    HomeMessageCell(messageCreator: .bytePal(message: "Why ?"))
                }
            }
            .padding()
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { userCellAppear = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { bytePalCellAppear = true}
            })
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
