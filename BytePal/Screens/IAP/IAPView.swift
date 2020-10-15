//
//  IAPView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/26/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import StoreKit

struct IAPView : View {

    @ObservedObject var productsStore : ProductsStore
    @State var show_modal = false
    
    var body: some View {
        VStack() {
            ForEach (productsStore.products, id: \.self) { prod in
                Text(prod.subscriptionStatus()).lineLimit(nil).frame(height: 80)
            }
            Button(action: {
                print("Button Pushed")
                self.show_modal = true
            }) {
                Text("Present")
            }.sheet(isPresented: self.$show_modal) {
                PurchaseView()
            }
        }
    }
}

/*
struct IAPView_Previews: PreviewProvider {
    //ProductsStore.shared.initializeProducts()
   
    static var previews: some View {
        
        IAPView(productsStore: ProductsStore.shared)
    }
}*/
