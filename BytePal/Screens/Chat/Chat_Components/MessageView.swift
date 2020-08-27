//
//  MessageView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI

// Use this for mainting message history between views
class Messages: ObservableObject {
    @Published var list = [MessageView]()
}

//  Message View
struct MessageView: View, Identifiable {
    var id: UUID
    var message: MessageInformation
    var body: some View {
        HStack (alignment: .bottom, spacing: 16) {
            if message.isCurrentUser == true { Spacer() }
            MessageBubble(message: message.content, isCurrentUser: message.isCurrentUser)
                .padding(
                    message.isCurrentUser ?
                    EdgeInsets(top: 8, leading: 40, bottom: 8, trailing: 8) :
                    EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 40)
                )
            if message.isCurrentUser == false {Spacer() }
        }
    }
}
