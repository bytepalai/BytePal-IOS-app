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
    @ObservedObject var viewModel: IAPViewModel
    @State var show_modal = false
    
    var body: some View {
        GeometryReader {geometry in
            ScrollView {
                if #available(iOS 14.0, *) {
                    LazyVGrid(columns: [GridItem(.flexible() )]) {
                        ForEach(viewModel.subscriptions) { (subscription)  in
                            SubscriptionCell(subscription: subscription)
                                .padding()
                        }
                        TermsOfConditionView()
                    }
                } else {
                    ForEach(viewModel.subscriptions) { (subscription)  in
                        SubscriptionCell(subscription: subscription)
                            .padding()
                    }
                    TermsOfConditionView()
                }
            }
        }
    }
}

//MARK: SubViews
struct SubscriptionCell: View {
    var subscription: IAPViewModel.Subscription
    var body: some View {
        ZStack {
            BackgroundImageView(subscription: subscription)
            
            SubscriptionCellTopView(subscription: subscription)
        }
            .background(Color.applightgreenPure)
            .cornerRadius(20, antialiased: true)
            .aspectRatio(1.5, contentMode: .fill)
            .animation(.interpolatingSpring(stiffness: 30, damping: 8) )
    }
}

struct BackgroundImageView: View {
    var subscription: IAPViewModel.Subscription
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                Spacer()
                subscription.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 2*proxy.size.height/3)
                Spacer()
            }
            .padding()
        }
    }
}

struct SubscriptionCellTopView: View {
    var subscription: IAPViewModel.Subscription
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Text(subscription.messageCountLabel)
                        .fontWeight(.bold)
                    Text(subscription.pricePerMonthLabel)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.appTransparentGray)
                        .cornerRadius(8)
                }
                .foregroundColor(.appFontColorBlack)
                
                Button(action: {
                    
                }, label: {
                    Text("Select")
                        .bold()
                        .padding(10)
                })
                .buttonStyle(WidthStrechyBackgroundButtonStyle(backgroundColor: .appGreen))
                .cornerRadius(5, antialiased: true)
                .shadow(radius: 2)
            }
            .padding()
            .background(Color.appTranspatentWhite)
            .cornerRadius(20)
            .padding(10)
            .shadow(color: .appLightGreen2, radius: 30)
        }
    }
}


struct TermsOfConditionView: View {
    var body: some View {
        
        VStack {
            TopButtonViews()
                .frame(height: 50)
            Text("Terms of use Restore purchases Privacy policy Premium subscription is required to get access to all wallpapers. Regardless whether the subscription has free trial period or not it automatically renews with the price and duration given above unless it is canceled at least 24 hours before the end of the current period. Payment will be charged to your Apple ID account at the confirmation of purchase. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
            
        }
        .padding()
        .background(Color.appTransparentGray)
        .cornerRadius(10)
        .padding()
    }
}

struct TopButtonViews: View {
    var body: some View {
        HStack {
            Spacer()
            Button("Terms of use") {
                
            }
            Spacer()
            Button("Restore purchases") {
                
            }
            Spacer()
            Button("Privacy policy") {
                
            }
            Spacer()
        }
        .buttonStyle(TransparentBackgroundButtonStyle(backgroundColor: .appTransparentGray, cornerRadious: 4))
        .foregroundColor(.appGreen)
    }
}



struct IAPView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            IAPView(productsStore: BytePal.ProductsStore.shared, viewModel: .init())
                .environment(\.colorScheme, .dark)
        }
        
        NavigationView {
            IAPView(productsStore: BytePal.ProductsStore.shared, viewModel: .init())
                .environment(\.colorScheme, .light)
        }
        
    }
    
}
