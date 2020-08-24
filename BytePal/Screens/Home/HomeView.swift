//
//  Home.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .fixedSize()
                Text("BytePal")
                    .font(.custom(fontStyle, size: 28))
            }
            VStack {
                ButtonCard(image: "bubble.left.fill", text: "You have 9,000 messages left", buttonText: "Upgrade")
                ButtonCard(image: "bubble.left.fill", text: "You have 9,000 messages left", buttonText: "Upgrade")
                ButtonCard(image: "bubble.left.fill", text: "You have 9,000 messages left", buttonText: "Upgrade")
            }
                .padding(16)
            NavigationBar()
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
