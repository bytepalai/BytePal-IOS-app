//
//  GoogleLoginButtonOnly.swift
//  BytePal
//
//  Created by may on 11/5/20.
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
                        .font(.custom(fontStyle, size: 24))
                        .foregroundColor(Color(UIColor.white))
                        .background(
                            Circle()
                                .fill(convertHextoRGB(hexColor: "DB3236"))
                                .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
                                .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                        )
                            .padding([.leading, .trailing], (width ?? CGFloat(100))*0.03)
                }
            }.onAppear(perform: {
            })
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
