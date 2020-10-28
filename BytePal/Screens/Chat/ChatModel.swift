//
//  ChatModel.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

// Use this for mainting message history between views
class UserInformation: ObservableObject {
    @Published var id: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var fullName: String = ""
    @Published var messagesLeft: Int = 0
    @Published var isLoggedIn: Bool = false
}
