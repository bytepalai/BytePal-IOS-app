//
//  MessagesJSONFormat.swift
//  BytePal
//
//  Created by Scott Hom on 8/27/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

let messageData: [Int: [String: Any]] = [
    0: [
        "id": UUID(),
        "content": "Hello",
        "isCurrentUser": true
    ],
    1: [
        "id": UUID(),
        "content": "How are you doing",
        "isCurrentUser": false
    ],
    2: [
        "id": UUID(),
        "content": "I am doing good. How about you?",
        "isCurrentUser": true
    ],
    3: [
        "id": UUID(),
        "content": "I am doing good as well",
        "isCurrentUser": false
    ],
    4: [
        "id": UUID(),
        "content": "What is your favorite color?",
        "isCurrentUser": true
    ],
    5: [
        "id": UUID(),
        "content": "Blue",
        "isCurrentUser": false
    ]
]

struct MessagesJSONFormat: View {
    var body: some View {
        VStack {
            Text("Messages")
            List {
                ForEach((0 ..< messageData.count), id: \.self) { i in
                    MessageView(id: messageData[i]!["id"] as! UUID, message: MessageInformation(content: messageData[i]!["content"] as! String, isCurrentUser: (messageData[i]!["isCurrentUser"] as! Bool)))
                }
            }
        }
    }
}

struct MessagesJSONFormat_Previews: PreviewProvider {
    static var previews: some View {
        MessagesJSONFormat()
    }
}
