//
//  HomeController.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI

//extension HomeView {
//    func updateHomeViewCards(attributes: [String: [String: String]]) -> [String: [String: String]] {
//        var mutatedAttributes = attributes
//
//        if self.messages.list.count != 0 {
//            let lastUserMessageIndex: Int = 1
//            let lastChatbotMessageIndex: Int = 0
//            print("---- FB (userInformation 2): \(self.userInformation.id)")
//            let messagesLeft: String = self.messages.getMessagesLeft(userID: self.userInformation.id)
//            let lastUserMessage: String = self.messages.list[lastUserMessageIndex]["content"] as? String ?? ""
//            let lastChatbotMessage: String = self.messages.list[lastChatbotMessageIndex]["content"] as? String ?? ""
//
//            mutatedAttributes["typing"]!["text"] = messagesLeft
//            mutatedAttributes["female user"]!["text"] = lastUserMessage
//            mutatedAttributes["BytePal"]!["text"] = lastChatbotMessage
//        }
//        else {
//            mutatedAttributes["typing"]!["text"] = self.messages.getMessagesLeft(userID: self.userInformation.id)
//            mutatedAttributes["female user"]!["text"] = "No messages sent to BytePal"
//            mutatedAttributes["BytePal"]!["text"] = "No messages receviec from BytePal"
//        }
//        return mutatedAttributes
//    }
//}
//
//class HomeController {
//    func textHomeViewCard(type: String, message: String) -> String {
////        let number: NumberController = NumberController()
//        
////        if type == "typing" {
////            let number: NumberController = NumberController()
////            var messagesLeftText: String = ""
////            messagesLeftText = number.commaSeperatedNumber(num: messages.getMessagesLeft())
////            return messagesLeftText
////        } else if type == "female user" {
////            return message
////        } else if type == "BytePal" {
////            return message
////        }
//
//        return "Error invalid HomeView Card type: received '\(type)'"
//    }
//}
