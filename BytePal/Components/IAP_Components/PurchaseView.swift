//
//  ContentView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit
import Combine

struct PurchaseView : View {
    var userID: String?
    @State private var isDisabled : Bool = false

    @Environment(\.presentationMode) var presentationMode

    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }

    var body: some View {

        ScrollView (showsIndicators: false) {
            VStack {
                Text("Get Premium Membership").font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                Text("Choose one of the packages below")
                    .font(.headline)
                    .foregroundColor(.secondary)

                self.purchaseButtons()
                //self.aboutText()

                ZStack{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(convertHextoRGB(hexColor: "ffffff"))
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.33), radius: 4, x: 3, y: 3)
                    VStack {
                        self.helperButtons()
                        self.termsText().frame(width: UIScreen.main.bounds.size.width)
                        self.dismissButton()

                    }
                    .background(convertHextoRGB(hexColor:"f8f4f4"))

                }

            }
            .background(convertHextoRGB(hexColor:"ebf6f5"))
            .frame(width : UIScreen.main.bounds.size.width)
        }.disabled(self.isDisabled)
    }

    // MARK:- View creations

    func purchaseButtons() -> some View {
        // remake to ScrollView if has more than 2 products because they won't fit on screen.
        VStack {
            ForEach(ProductsStore.shared.products, id: \.self) { prod in
                VStack {
                    PurchaseButton(block: {
                        self.purchaseProduct(userID: self.userID!, skproduct:prod)
                    }, product: prod).disabled(IAPManager.shared.isActive(product:prod))
                        Spacer()
                        Spacer()
                }
            }
        }
    }

    func helperButtons() -> some View{
        HStack {
            Button(action: {
                self.termsTapped()
            }) {
                Text("Terms of use").font(.footnote)
            }
            Button(action: {
                self.restorePurchases()
            }) {
                Text("Restore purchases").font(.footnote)
            }
            Button(action: {
                self.privacyTapped()
            }) {
                Text("Privacy policy").font(.footnote)
            }
            }.padding()
    }

    func aboutText() -> some View {
        Text("""
                • Unlimited searches
                • 100GB downloads
                • Multiplatform service
                """).font(.subheadline).lineLimit(nil)
    }

    func termsText() -> some View{
        // Set height to 600 because SwiftUI has bug that multiline text is getting cut even if linelimit is nil.
        VStack {
            Text(terms_text).font(.footnote).lineLimit(nil).padding()
            Spacer()
            }.frame(height: 350)
    }

    func dismissButton() -> some View {
        Button(action: {
            self.dismiss()
        }) {
            Text("Not now").font(.footnote)
            }.padding()
    }

    //MARK:- Actions

    func restorePurchases(){

        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            self.dismiss()

        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()

        }
    }

    func termsTapped(){

    }

    func privacyTapped(){

    }

    func purchaseProduct(userID: String, skproduct : SKProduct){
        print("did tap purchase product: \(skproduct.productIdentifier)")
        isDisabled = true
        
        IAPManager.shared.userID = userID
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
            self.dismiss()
        }) { (error) in
            self.isDisabled = false
            ProductsStore.shared.handleUpdateStore()
        }
    }
}
