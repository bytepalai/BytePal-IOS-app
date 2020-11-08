//
//  BuyingView.swift
//  BytePal
//
//  Created by may on 7/12/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI

struct BuyView: View {
  @Binding var purchased:Bool
  @ObservedObject var products = productsDB.shared
  var body: some View {
  List {
    ForEach((0 ..< self.products.items.count), id: \.self) { column in
      Text(self.products.items[column].localizedDescription)
        .onTapGesture {
            IAPManager.shared.purchaseV5(product: self.products.items[column])
      }
    }
  }
 }
}
