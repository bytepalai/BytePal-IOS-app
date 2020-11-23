//
//  HomeMessageCell.swift
//  BytePal
//
//  Created by Scott Hom on 10/23/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HomeMessageCellOnly: View {
    var messageCreator: messagecreater
    
    var body: some View {
        
        Group{
            switch messageCreator {
            
            case .user:
                    HStack {
                        Spacer(minLength: 40)
                        HStack {
                            MessageBodyTextsOnly(messageCreator: messageCreator)
                            HomeMessageCellImageOnly(messageCreator: messageCreator)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        }
                        .padding()
                        .background(getBackgroundColor(accordingTo: messageCreator))
                        .cornerRadius(30)
                    }
                    .transition(.move(edge: .trailing))
                
            case .bytePal:
                HStack {
                    HStack {
                        HomeMessageCellImageOnly(messageCreator: messageCreator)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                        MessageBodyTextsOnly(messageCreator: messageCreator)
                    }
                    .padding()
                    .background(getBackgroundColor(accordingTo: messageCreator))
                    .cornerRadius(30)
                    Spacer(minLength: 40)
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.interpolatingSpring(stiffness: 30, damping: 8))
        .padding()
    }
    
    enum messagecreater {
        case user(message: String)
        case bytePal(message: String)
        
        
        
        var title: String {
            switch self {
            case .user:
                return "Your last mesage"
            case .bytePal:
                return "BytePal's last message"
            }
        }
        
        var message: String {
            switch self {
            case .user(let message):
                return message
            case .bytePal(let message):
                return message
            }
        }
    }
    
    private func getBackgroundColor(accordingTo messageCreator: messagecreater) -> Color {
        switch messageCreator {
        
        case .user(message: _):
            return .appGreen
            
        case .bytePal(message: _):
            return .appLightGreen2
        }
    }
}

struct HomeMessageCellOnly_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeMessageCellOnly(messageCreator: .user(message: "hi I am user"))
            HomeMessageCellOnly(messageCreator: .bytePal(message: "hi I am BytePal"))
        }
    }
}

//MARK: Sub views
struct MessageBodyTextsOnly: View {
    var messageCreator: HomeMessageCellOnly.messagecreater
    
    var body: some View {
        VStack(alignment: getAlignment(from: messageCreator)) {
            Text(messageCreator.title)
                .foregroundColor(getMessageTitleColor(acordingTo: messageCreator))
                .fontWeight(.bold)
            Text(messageCreator.message)
                .font(title2Custom)
                .fontWeight(.semibold)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)
            
            //here we have given explicit animation so that parents animation will not work here
            Button(action: {
                print("Go to Chat View")
            }){
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title)
                    .animation(
                        Animation.interpolatingSpring(stiffness: 50, damping: 10, initialVelocity: 0)
                    )
            }
        }
        .foregroundColor(getFontColor(acordingTo: messageCreator) )
    }
    
    //MARK: Constants and methods
    func getAlignment(from messageCreator: HomeMessageCellOnly.messagecreater) -> HorizontalAlignment {
        
        switch messageCreator {
        
        //chage if needed
        case .user(message: _):
            return .leading
            
        case .bytePal(message: _):
            return .leading
        }
    }
    
    private func getFontColor(acordingTo messageCreator: HomeMessageCellOnly.messagecreater) -> Color {
        switch messageCreator {
        
        case .user(message: _):
            return .white
            
        case .bytePal(message: _):
            return .appFontColorBlack
            
        }
    }
    
    private func getMessageTitleColor(acordingTo messageCreator: HomeMessageCellOnly.messagecreater) -> Color{
        switch messageCreator {
        
        case .user(message: _):
            return .appTransparentGray
            
        case .bytePal(message: _):
            return .gray
            
        }
    }
}

struct HomeMessageCellImageOnly: View {
    var messageCreator: HomeMessageCellOnly.messagecreater

    var body: some View {
        
        VStack {
            getImage(releventTo: messageCreator)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 100, alignment: .top)
            Spacer()
        }
        
    }

    private func getImage(releventTo messageCreator: HomeMessageCellOnly.messagecreater) -> Image {
        
        switch messageCreator {
            //chage if needed
            case .user(message: _):
                return Image("homePerson")
                
            case .bytePal(message: _):
                return Image("homeRobot")
        }
        
    }
    
}
    



