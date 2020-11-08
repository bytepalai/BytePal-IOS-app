//
//  ProductDB.swift
//  BytePal
//
//  Created by may on 7/12/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import StoreKit

final class productsDB: ObservableObject, Identifiable {
  static let shared = productsDB()
  var items:[SKProduct] = []
  {
    willSet {
      DispatchQueue.main.async {
        self.objectWillChange.send()
      }
    }
  }
}
