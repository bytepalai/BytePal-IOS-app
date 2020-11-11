//
//  ProductsStore.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import StoreKit

class ProductsStore : ObservableObject {
    
    static let shared = ProductsStore()
    
    @Published var products: [SKProduct] = []
    @Published var anyString = "123" // little trick to force reload ContentView from PurchaseView by just changing any Published value
    
    func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    func initializeProducts(){
        IAPManager.shared.startWith(arrayOfIds: [subscription_1, subscription_2, subscription_3], sharedSecret: shared_secret) { products in
            self.products = products
            
            let temp = self.products[0]
            self.products[0] = self.products[2]
            let temp2 = self.products[1]
            self.products[1] = temp
            self.products[2] = temp2
            
        }
    }
}
