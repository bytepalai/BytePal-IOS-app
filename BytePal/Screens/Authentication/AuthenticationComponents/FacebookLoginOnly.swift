//
//  FacebookLoginButtonOnly.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// FacebookLoginButton (height: 7%)
struct FacebookLoginButtonOnly: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        Button(action: {
            print("Login Facebook")
        }){
            VStack {
                Text("f")
                    .font(.custom(fontStyle, size: 30))
                    .foregroundColor(Color(UIColor.white))
                    .background(
                        Circle()
                            .fill(convertHextoRGB(hexColor: "3B5998"))
                            .frame(width: CGFloat(36), height: CGFloat(36))
                            .shadow(color: Color(UIColor.black).opacity(0.70), radius: 4, x: 3, y: 3)
                    )
                        .padding([.trailing], (width ?? CGFloat(100))*0.06)
            }
        }
    }
}


struct FacebookLoginButtonOnly_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginButtonOnly(
            width: CGFloat(414),
            height: CGFloat(800)
        )
    }
}
