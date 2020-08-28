//
//  MessagesModel.swift
//  BytePal
//
//  Created by may on 8/27/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

// Use this for mainting message history between views
class Messages: ObservableObject {
    @Published var list: [[String: Any]] = [[String: Any]]()
    @Published var messagesLeft: Int = -1
    @Published var lastMessages: [String] = [String]()
}
