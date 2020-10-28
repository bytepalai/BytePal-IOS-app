//
//  MessageBubble.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI

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
            .font(.custom(fontStyle, size:18))
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message:"Good, morning BytePal",isCurrentUser:true)
        MessageBubble(message:"Good, morning to you to John",isCurrentUser:false)
    }
}
