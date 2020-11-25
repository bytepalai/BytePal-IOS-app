//
//  GoogleLoginButtonOnly.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// GoogleLoginButton (height: 7%)
struct GoogleLoginButtonOnly: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        VStack {
            Group {
                Button(action: {
                    print("Login Google")
                }){
                    Text("G")
                        .font(.custom(fontStyle, size: 26))
                        .foregroundColor(Color(UIColor.white))
                        .background(
                            Circle()
                                .fill(convertHextoRGB(hexColor: "DB3236"))
                                .frame(width: CGFloat(36), height: CGFloat(36))
                                .shadow(color: Color(UIColor.black).opacity(0.60), radius: 4, x: 3, y: 3)
                        )
                            .padding([.leading, .trailing], (width ?? CGFloat(100))*0.04)
                }
            }
        }
    }
}
struct GoogleLoginButtonOnly_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButtonOnly(
            width: CGFloat(414),
            height: CGFloat(800)
        )
    }
}
