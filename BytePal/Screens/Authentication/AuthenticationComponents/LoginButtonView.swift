//
//  LoginButtonView.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// LoginButtonView (height: 9%)
struct LoginButtonView: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        Text("Login")
            .padding((height ?? CGFloat(200))*0.01)
            .font(.custom(fontStyle, size: 20))
            .foregroundColor(Color(UIColor.black))
            .cornerRadius(15)
            .shadow(color: convertHextoRGB(hexColor: "888888").opacity(0.64), radius: 3, x: 1, y: 3)
            .background(
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: (width ?? CGFloat(100))*0.18, height: (height ?? CGFloat(200))*0.04)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.16), radius: 6, x: -2, y: -2)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: (width ?? CGFloat(100))*0.18, height: (height ?? CGFloat(200))*0.04)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 5, y: 5)
                }
                
            )
            .padding([.bottom], (height ?? CGFloat(200))*0.04)
    }
}

struct LoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtonView(
            width: 414,
            height: 800
        )
    }
}
