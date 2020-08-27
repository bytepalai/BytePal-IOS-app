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
    
    
    var body: some View {
        
        Button(action: { 
            self.block()
            print("price is", self.product.localizedPrice())
        }) {
            Text(product.localizedPrice()).lineLimit(nil).multilineTextAlignment(.center).font(.subheadline)
            }.padding().frame(height: 50).scaledToFill().border(Color.blue, width: 1)
    }
}
