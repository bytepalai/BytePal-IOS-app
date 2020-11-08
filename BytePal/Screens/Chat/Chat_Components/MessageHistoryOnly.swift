//
//  MessageHistory.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct MessageHistoryOnly: View {
    var width: CGFloat
    var height: CGFloat
    @State public var textFieldString: String = ""
    var messageString: String = ""
    
//    init() {
//        if #available(iOS 14.0, *) {
//            // iOS 14 doesn't have extra separators below the list by default.
//        } else {
//            // To remove only extra separators below the list:
//            UITableView.appearance().tableFooterView = UIView()
//        }
//
//        // To remove all separators including the actual ones:
//        UITableView.appearance().separatorStyle = .none
//    }
    
    var body: some View {
        VStack {
            // Render message history from bottom to top
            ScrollView {
                ForEach((0 ..< 15), id: \.self) { i in
                    MessageView(id: UUID(), message: MessageInformation(content: "Good morning!", isCurrentUser: true))
                    .rotationEffect(.radians(.pi))
                }
            }
                .rotationEffect(.radians(.pi))
                .frame(width: width, height: height*0.72)
                .onAppear {    
                    if #available(iOS 14.0, *) {
                        // iOS 14 doesn't have extra separators below the list by default.
                    } else {
                        // To remove only extra separators below the list:
                        UITableView.appearance().tableFooterView = UIView()
                    }

                    // To remove all separators including the actual ones:
                    UITableView.appearance().separatorStyle = .none
                    UITableView.appearance().separatorColor = .clear
                }
            
            DividerCustom(color: Color(UIColor.systemGray3), length: Float(width), width: 1)
                .shadow(color: Color(UIColor.systemGray4), radius: 1, x: 0, y: -1)
            
            // MessageBar (height: 8%)
            MessageBarOnly(
                width: width,
                height: height,
                textFieldString: self.$textFieldString
            )
            
            // Navigation bar (height: 10%)
            NavigationBarOnly(
                width: width,
                height: height*0.10,
                color: Color(UIColor.systemGray3)
            )
        }
            .frame(alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct MessageBarOnly: View {
    var width: CGFloat
    var height: CGFloat
    @Binding var textFieldString: String
        
    var body: some View {
        // Message Bar
        HStack {
            // Text Box with TTS Button
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)                                          // Text box border
                    .fill(Color(UIColor.white))
                    .frame(width: width - 66 , height: 40)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .shadow(
                        color: convertHextoRGB(hexColor: "000000")
                            .opacity(0.33),
                        radius: 4,
                        x: 3,
                        y: 3
                    )
                
                // Text box entry area
                // Single Line Text Field
                TextField("Enter text here", text: self.$textFieldString)
                    .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 48))
            }
                .padding([.top], 16)

            // Send message button
            Button(action: {
                print("Send message")
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
                height: height*0.02,
                alignment: .top
            )
            .padding([.bottom], height*0.06)
    }
}

#if DEBUG
struct MessageHistoryOnly_Previews: PreviewProvider {
    static var previews: some View {
        
//        MessageHistoryOnly()
//            .environment(\.colorScheme, .dark)
        
        MessageHistoryOnly(width: CGFloat(414), height: CGFloat(850))
            .environment(\.colorScheme, .light)
    }
}
#endif
