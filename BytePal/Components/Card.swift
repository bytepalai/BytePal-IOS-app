//
//  CardView.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ButtonCard: View {
    var type: String
    var title: String
    var image: String
    var text: String
    var buttonText: String
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @State var isShowingIAPView: Bool = false
    @State var isShowingChatView: Bool = false
    
    func updateView(type: String) {
        switch type {
            case "typing":
                self.isShowingIAPView = true
            case "female user", "BytePal":
                self.isShowingChatView = true
            default:
                print("Error")
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.white))
                .frame(width: 300, height: 160)
                .cornerRadius(10)
                .shadow(radius: 3)
            HStack {
                    Image(image)
                        .resizable()
                        .frame(width: 72,height: 72)
                    VStack {
                        Text(title)
                            .font(.custom(fontStyle, size: 18))
                            .padding(16)
                        Text(text)
                            .lineLimit(nil)
                            .font(.custom(fontStyle, size: 16))
                        Button(action: {
                            self.updateView(type: self.type)
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(convertHextoRGB(hexColor: greenColor))
                                    .frame(width: 200, height: 32)
                                Text(buttonText)
                                    .font(.custom(fontStyle, size: 16))
                                    .foregroundColor(Color(UIColor.white))
                            }
                        }
                    }
                NavigationLink(destination: IAPView().environmentObject(messages).environmentObject(userInformation), isActive: self.$isShowingIAPView){EmptyView()}
                NavigationLink(destination: ChatView().environmentObject(messages).environmentObject(userInformation), isActive: self.$isShowingChatView){EmptyView()}
            }
                .padding(16)
        }
        .padding(16)
    }
}

struct Divider: View {
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.black))
            .frame(width: 300, height: 1)
            .shadow(color: Color(UIColor.black).opacity(0.04), radius: 3, x: 3, y: 3)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
