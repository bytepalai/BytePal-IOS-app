//
//  Navigation.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct NavigationBarOnly: View {
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: "house.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 64))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 32, trailing: 0))
                Image(systemName: "person.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                    .padding(EdgeInsets(top: 0, leading: 64, bottom: 32, trailing: 0))
            }
                .frame(width: geometry.size.width, height: 104)
                .background(convertHextoRGB(hexColor: "9FA7A3"))
                .shadow(radius: 1)
        }
        
    }
    
}

struct NavigationBarOnly_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarOnly()
    }
}
