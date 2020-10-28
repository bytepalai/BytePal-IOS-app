//
//  MessageHistory.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct MessageHistoryOnly: View{
    @State public var textFieldString: String = ""
    var messageString: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                // Render message history from bottom to top
                VStack {
                    List {
                        MessageView(id: UUID(), message: MessageInformation(content: "Good morning!", isCurrentUser: true))
                        .rotationEffect(.radians(.pi))
                        MessageView(id: UUID(), message: MessageInformation(content: "Good morning!", isCurrentUser: false))
                        .rotationEffect(.radians(.pi))
                        MessageView(id: UUID(), message: MessageInformation(content: "Good morning!", isCurrentUser: true))
                        .rotationEffect(.radians(.pi))
                        MessageView(id: UUID(), message: MessageInformation(content: "Good morning!", isCurrentUser: false))
                        .rotationEffect(.radians(.pi))
                        
                    }
                        .rotationEffect(.radians(.pi))
                        .frame(width: geometry.size.width, height: 540, alignment: .bottom)
                }

                // Message Bar
                HStack {
                    GeometryReader { geometry in
                        // Text Box with TTS Button
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)                                          // Text box border
                                .fill(convertHextoRGB(hexColor: "ffffff"))
                                .frame(width: geometry.size.width - 16 , height: 40)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
                            // Text box entry area
                            // Single Line Text Field
                            TextField("Enter text here", text: self.$textFieldString)
                                .padding(EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 48))
                        }
                    }
                    // Send message button
                    Button(action: {
                        print("Send message")
                    }){
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(convertHextoRGB(hexColor: greenColor))
                            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 6)
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                }
                .frame(width: geometry.size.width, height: 70, alignment: .bottom)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .background(Color(UIColor.white).opacity(20))
                
                // Navigation Bar
                NavigationBarOnly()
                    .frame(width: geometry.size.width, height: 80)
            }
        }
    }
}

#if DEBUG
struct MessageHistoryOnly_Previews: PreviewProvider {
    static var previews: some View {
        MessageHistoryOnly()
    }
}
#endif
