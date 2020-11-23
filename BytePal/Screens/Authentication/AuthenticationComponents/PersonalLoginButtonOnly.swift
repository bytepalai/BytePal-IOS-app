//
//  PersonalLoginButtonOnly.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// PersonalLoginButton (height: 7%)
struct PersonalLoginButtonOnly: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        Image(systemName: "envelope.fill")
            .font(.system(size: 16))
            .foregroundColor(Color(UIColor.white))
            .shadow(color: Color(UIColor.black).opacity(0.32), radius: 6, x: 3, y: 3)
            .background(
                Circle()
                    .fill(convertHextoRGB(hexColor: "1757A8"))
                    .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
            )
                .padding(EdgeInsets(top: 0, leading: (width ?? CGFloat(100))*0.04, bottom: 0, trailing: (width ?? CGFloat(100))*0.03))
    }
}

struct PersonalLoginButtonOnly_Previews: PreviewProvider {
    static var previews: some View {
        PersonalLoginButtonOnly(
            width: CGFloat(414),
            height: CGFloat(800)
        )
    }
}
