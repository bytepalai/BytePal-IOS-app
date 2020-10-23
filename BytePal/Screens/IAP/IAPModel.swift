//
//  IAPModel.swift
//  BytePal
//
//  Created by may on 10/23/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

class IAPViewModel: ObservableObject {
    var subscriptions = [
        Subscription(price: 14.99, messageCount: -1, imageName: "unlimitedMessages"),
        Subscription(price: 11.99, messageCount: 10000, imageName: "10000Messages"),
        Subscription(price: 9.99, messageCount: 5000, imageName: "5000Messages")]
    
    struct Subscription: Identifiable {
        var id: UUID = UUID()
        var price: Double
        var messageCount: Int
        var imageName: String
        
        var messageCountLabel: String {
            messageCount == -1 ? "Unlimited Messages":"\(messageCount) Messages"
        }
        var pricePerMonthLabel: String {
            "$ \(price) / Month "
        }
        
        var image: Image {
            Image(imageName)
        }
    }
}
