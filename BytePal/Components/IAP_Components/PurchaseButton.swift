//
//  PurchaseButton.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//


import Foundation
import SwiftUI
import StoreKit

struct PurchaseButton : View {
    
    var block : SuccessBlock!
    var product : SKProduct!

    @State private var image = ""
    @State private var plan = ""
    @State private var price = ""
    @State private var action = ""
       
    
    var body: some View {
        
        Button(action: {
            self.block()
            print("price is", self.product.localizedPrice())
            print(self.product.localizedPrice())
            //Spacer()
           
        }) {
            IAPCard(price:String(self.product.localizedPrice()))
            //Spacer()
            
            //Text(product.localizedPrice()).lineLimit(nil).multilineTextAlignment(.center).font(.subheadline)
            }
    }
        
}
