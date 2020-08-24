//
//  IAPManager.swift
//  BytePal
//
//  Created by may on 7/2/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import StoreKit
import Combine


class IAPManager: NSObject {
    static let shared = IAPManager()
    private override init() {
    super.init()
    }

//  Init
    let purchasePublisher = PassthroughSubject<(String, Bool), Never>()
    var totalRestoredPurchases: Int = 0
    
//  Get product ID
    func returnProductIDs() -> Set<String> {
        let productIDs: Set = Set([
            "io.bytepal.www.consumable",
            "BytePal_AI.BytePal_Temp.Subscription"
        ])
      return productIDs
    }
    
    
//  Get name of IAPs from AppStore
    func getProductsV5() {
      let productIDs = Set(returnProductIDs())
      let request = SKProductsRequest(productIdentifiers: Set(productIDs))
      request.delegate = self
      request.start()
    }
    
    
//  Get price of IAPs from App Store
    func getPriceFormatted(for product: SKProduct) -> String? {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.locale = product.priceLocale
      return formatter.string(from: product.price)
    }
}

// Handle App Store Request
extension IAPManager: SKProductsRequestDelegate, SKRequestDelegate {
//  Request to App Store
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let badProducts = response.invalidProductIdentifiers
        let goodProducts = response.products
        if goodProducts.count > 0 {
            productsDB.shared.items = response.products
            print("bon ",productsDB.shared.items)
        }
        else {
            print("badProducts ",badProducts)
        }
    }
    
//  Display request to AppStore fail
    internal func request(_ request: SKRequest, didFailWithError error: Error) {
      print("didFailWithError ",error)
      purchasePublisher.send(("Purchase request failed ",true))
    }

//  Display request to AppStore success
    internal func requestDidFinish(_ request: SKRequest) {
      print("request did finish")
    }
}

// Handle Payment and States
extension IAPManager: SKPaymentTransactionObserver {
    func startObserving() {
      SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
      SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
      return SKPaymentQueue.canMakePayments()
    }
    
//  Purcahse
    func purchaseV5(product: SKProduct) -> Bool {
      if !IAPManager.shared.canMakePayments() {
        return false
      } else {
        let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(payment)
      }
      return true
    }
    
    
//  Handle transactions
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    purchasePublisher.send(("Purchased ",true))
                case .restored:
                    totalRestoredPurchases += 1
                    SKPaymentQueue.default().finishTransaction(transaction)
                    purchasePublisher.send(("Restored ",true))
                case .failed:
                    if let error = transaction.error as? SKError {
                        purchasePublisher.send(("Payment Error \(error.code) ",false))
                        print("Payment Failed \(error.code)")
                        print("Error Code: \(error.errorCode)")
                        print("NS Error: \(error._nsError)")
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .deferred:
                    print("Ask Mom ...")
                    purchasePublisher.send(("Payment Diferred ",false))
                case .purchasing:
                    print("working on it...")
                    purchasePublisher.send(("Payment in Process ",false))
                default:
                    break
            }
        }
    }
    
//  Restore prucahse
    func restorePurchasesV5() {
      totalRestoredPurchases = 0
      SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
//  Display transaction completion
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
      if totalRestoredPurchases != 0 {
          purchasePublisher.send(("IAP: Purchases successfull restored!",true))
      } else {
          purchasePublisher.send(("IAP: No purchases to restore!",true))
      }
    }
    
//  Handle payment error
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
      if let error = error as? SKError {
          if error.code != .paymentCancelled {
              purchasePublisher.send(("IAP Restore Error: " + error.localizedDescription,false))
          } else {
              purchasePublisher.send(("IAP Error: " + error.localizedDescription,false))
          }
      }
    }
}
