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
        
    // BytePal singelton Object
    static let shared = ProductsStore()

    // Products list
    @Published var products: [SKProduct] = []
    
    // little trick to force reload ContentView from PurchaseView by just changing any Published value
    @Published var anyString = "123"
    
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
