//
//  CardView.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ButtonCard: View {
    var image: String
    var text: String
    var buttonText: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(UIColor.white))
                .frame(width: 300, height: 160)
                .cornerRadius(10)
                .shadow(radius: 3)
            VStack {
                HStack {
                    Image(systemName: image)
                        .font(.system(size: 34))
                        .foregroundColor(convertHextoRGB(hexColor: "eaeeed"))
                        .shadow(radius: 0)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                    Text("You have 9,000 messages left")
                        .font(.custom(fontStyle, size: 16))
                }
                NavigationLink(destination: UpgradeView()) {
                    Button(action: {
                        
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(convertHextoRGB(hexColor: greenColor))
                                .frame(width: 200, height: 32)
                            Text("Upgrade")
                                .font(.custom(fontStyle, size: 16))
                                .foregroundColor(Color(UIColor.white))
                        }
                    }
                    .padding(16)
                }
            }
        }
            .padding(8)   
    }
}

struct TextBytePal: View {
    var body: some View {
        Text("Hello World")
            .font(.custom(fontStyle, size: 16))
    }
}

struct Divider: View {
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.black))
            .frame(width: 300, height: 1)
            .shadow(color: Color(UIColor.black).opacity(0.04), radius: 3, x: 3, y: 3)
    }
}
