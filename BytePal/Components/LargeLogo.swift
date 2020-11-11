//
//  LargeLogo.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// LargeLogo (height: 41%)
struct LargeLogo: View {
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        VStack {
            
            // Logo (height: 15%)
            Image("logo")
                .resizable()
                .frame(width: (height ?? CGFloat(200))*0.20, height: (height ?? CGFloat(200))*0.20)
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.35), radius: 5, x: 5, y: 7)
            
            // App Name (height: 26%)
            Text("BytePal")
                .font(.custom(fontStyle, size: 32))
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.24), radius: 3, x: 3, y: 6)
                .foregroundColor(Color(UIColor.white))
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(convertHextoRGB(hexColor: "1864C4"))
                        .frame(width: (width ?? CGFloat(200))*0.75, height: (height ?? CGFloat(100))*0.075)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 6, y: 8)
                )
                .padding((height ?? CGFloat(200))*0.02)
        }
        .padding(
            EdgeInsets(
                top: (height ?? CGFloat(200))*0.125,
                leading: 16,
                bottom: (height ?? CGFloat(200))*0.025,
                trailing: 16
            )
        )
    }
}

struct LargeLogo_Previews: PreviewProvider {
    static var previews: some View {
        LargeLogo(
            width: 414,
            height: 800
        )
    }
}
