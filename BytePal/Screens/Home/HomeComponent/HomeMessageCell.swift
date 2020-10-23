//
//  HomeMessageCell.swift
//  BytePal
//
//  Created by may on 10/23/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

import SwiftUI


struct HomeMessageCell: View {
    var messageCreator: messagecreater
    
    var body: some View {
        
        Group{
            switch messageCreator {
            
            case .user:
                    HStack {
                        Spacer(minLength: 40)
                        HStack {
                            MessageBodyTexts(messageCreator: messageCreator)
                            HomeMessageCellImage(messageCreator: messageCreator)
                        }
                        .padding()
                        .background(getBackgroundColor(accordingTo: messageCreator))
                        .cornerRadius(30)
                    }
                    .transition(.move(edge: .trailing))
                
            case .bytePal:
                HStack {
                    HStack {
                        HomeMessageCellImage(messageCreator: messageCreator)
                        MessageBodyTexts(messageCreator: messageCreator)
                    }
                    .padding()
                    .background(getBackgroundColor(accordingTo: messageCreator))
                    .cornerRadius(30)
                    Spacer(minLength: 40)
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.interpolatingSpring(stiffness: 30, damping: 8) )
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

struct HomeMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeMessageCell(messageCreator: .user(message: "hi I am user"))
            HomeMessageCell(messageCreator: .bytePal(message: "hi I am BytePal"))
        }
    }
}

//MARK: Sub views
struct MessageBodyTexts: View {
    var messageCreator: HomeMessageCell.messagecreater
    
    var body: some View {
        VStack(alignment: getAlignment(from: messageCreator)) {
            Text(messageCreator.title)
                .foregroundColor(getMessageTitleColor(acordingTo: messageCreator))
                .fontWeight(.bold)
            if #available(iOS 14.0, *) {
                Text(messageCreator.message)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 14.0, *) {
                Text(Image(systemName: "arrow.right.circle.fill"))
                    .font(.title)
                    .animation(
                        Animation.interpolatingSpring(stiffness: 50, damping: 10, initialVelocity: 0)
                    )
            } else {
                // Fallback on earlier versions
            }
                //here we have given explicit animation so that parents animation will not work here
        }
        .foregroundColor(getFontColor(acordingTo: messageCreator) )
    }
    
    //MARK: Constants and methods
    func getAlignment(from messageCreator: HomeMessageCell.messagecreater) -> HorizontalAlignment {
        
        switch messageCreator {
        
        //chage if needed
        case .user(message: _):
            return .leading
            
        case .bytePal(message: _):
            return .leading
        }
    }
    
    private func getFontColor(acordingTo messageCreator: HomeMessageCell.messagecreater) -> Color {
        switch messageCreator {
        
        case .user(message: _):
            return .white
            
        case .bytePal(message: _):
            return .appFontColorBlack
            
        }
    }
    
    private func getMessageTitleColor(acordingTo messageCreator: HomeMessageCell.messagecreater) -> Color{
        switch messageCreator {
        
        case .user(message: _):
            return .appTransparentGray
            
        case .bytePal(message: _):
            return .gray
            
        }
    }
}

struct HomeMessageCellImage: View {
    var messageCreator: HomeMessageCell.messagecreater
    
    var body: some View {
        VStack {
            getImage(releventTo: messageCreator)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 100, alignment: .top)
            Spacer()
        }
    }
    
    private func getImage(releventTo messageCreator: HomeMessageCell.messagecreater) -> Image {
        
    switch messageCreator {
    
    //chage if needed
    case .user(message: _):
        return Image("homePerson")
        
    case .bytePal(message: _):
        return Image("homeRobot")
    }
}
}


