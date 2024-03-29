//
//  LoginModel.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

let userNoMessages: String = "Start a conversation with BytePal."
let chatbotNoMessages: String = "I can't wait to talk to you."

class LoginViewModel: ObservableObject {
    @Published var isShowingChatView: Bool = false
}
