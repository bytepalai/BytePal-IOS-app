//
//  Extensions.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import StoreKit



extension SKProduct {
    
    func subscriptionStatus() -> String {
        if let expDate = IAPManager.shared.expirationDateFor(productIdentifier) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            let dateString = formatter.string(from: expDate)
            
            if Date() > expDate {
                print("Subscription expired: \(localizedTitle) at: \(dateString)")
                return "Subscription expired: \(localizedTitle) at: \(dateString)"
            } else {
                print("Subscription active: \(localizedTitle) until:\(dateString)")
                return "Subscription active: \(localizedTitle) until:\(dateString)"
            }
        } else {
            print("Subscription not purchased: \(localizedTitle)")
            return "Subscription not purchased: \(localizedTitle)"
        }
    }
    
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        let text = formatter.string(from: price)
        let period = subscriptionPeriod!.unit
        var periodString = ""
        switch period {
        case .day:
            periodString = "day"
        case .month: 
            periodString = "month"
        case .week:
            periodString = "week"
        case .year:
            periodString = "year"
        default:
            break
        }
        let unitCount = subscriptionPeriod!.numberOfUnits
        let unitString = unitCount == 1 ? periodString : "\(unitCount) \(periodString)s"
        print("got called")
        print("text", text)
        return text!
        //return (text ?? "") + "\nper \(unitString)"
    }
}
