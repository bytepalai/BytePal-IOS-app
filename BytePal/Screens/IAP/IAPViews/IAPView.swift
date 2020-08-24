//
//  IAPView.swift
//  BytePal
//
//  Created by may on 7/12/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct IAPView: View {
//    @Binding var purchased:Bool
    @ObservedObject var products = productsDB.shared
    @State var purchased: Bool = true
        
    var body: some View {
        VStack {
            Button(action: {
                IAPManager.shared.getProductsV5()
            }){
                Text("Get")
            }
            List {
                ForEach((0 ..< self.products.items.count), id: \.self) { column in
                    Text(self.products.items[column].localizedDescription)
                        .onTapGesture {
                            _ = IAPManager.shared.purchaseV5(product: self.products.items[column])
                        }
                }
            }
            Button("Restore") {
              IAPManager.shared.restorePurchasesV5()
            }
        }
            
    }
}

struct IAPView_Previews: PreviewProvider {
    static var previews: some View {
        IAPView()
    }
}
