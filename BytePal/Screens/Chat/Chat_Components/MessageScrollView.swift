//
//  MessageScrollView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct MessageScrollView: View {
    var width: CGFloat?
    var height: CGFloat?
    @EnvironmentObject var messages: Messages
    @ObservedObject var keyboard = KeyboardResponder()
    
    var body: some View {
        
        // Render messages (height: 72%)
        ScrollView {
            ForEach((0 ..< self.messages.list.count), id: \.self) { i in
                MessageView(id: self.messages.list[i]["id"] as! UUID, message: MessageInformation(content: self.messages.list[i]["content"] as! String, isCurrentUser: self.messages.list[i]["isCurrentUser"] as! Bool))
                    .rotationEffect(.radians(.pi))
            }
        }
            .frame(
                width: (width ?? CGFloat(100)),
                height: self.keyboard.isUp ?
                    ((height ?? CGFloat(200))*0.82 - keyboard.currentHeight):   // keyboard up (+ 8% for nav. bar)
                    ((height ?? CGFloat(200))*0.72)
            )
            .rotationEffect(.radians(.pi))
            .onAppear {
                print("----- messages (ScrollView): ")
                print(messages.list)
                
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
    }
}
