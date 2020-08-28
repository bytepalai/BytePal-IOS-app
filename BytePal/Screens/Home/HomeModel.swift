//
//  HomeModel.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

let titleLogoSize: Int = 60
let titleTextSize: Int = 28
    
var lastMessages: [String: String] = [
    "lastUserMessage": "",
    "lastChatbotMessage": ""
]

// Card Type and order in which cards appear from top to bottom
let homeViewCardType: [String] = [
    "typing",
    "female user",
    "BytePal",
    "BytePal",
    "BytePal"
    ]
