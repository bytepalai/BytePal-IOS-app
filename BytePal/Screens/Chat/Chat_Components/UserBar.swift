//
//  UserBar.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI
import CoreData

//  User Inforamtion Bar (Top)
struct UserBar: View {
    // UserBar View
    var width: CGFloat
    var sideSquareLength: CGFloat
    
    var body: some View {
        
        VStack {
            ZStack{
                
                Spacer()
                
                // Logo
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: sideSquareLength, height: sideSquareLength)
                        .frame(alignment: .center)
                }
                    .frame(
                        width: width,
                        height: sideSquareLength,
                        alignment: .center
                    )
                    .padding([.bottom], 8)
                
                Spacer()
                    
            }
                
            DividerCustom(
                color: Color(UIColor.systemGray3),
                length: Float(width),
                width: 1
            )
                .shadow(color: Color(UIColor.systemGray), radius: 1, x: 0, y: 1)
        }
            .frame(
                width: width,
                height: sideSquareLength,
                alignment: .center
            )
    }
    
}

//struct UserBar_Previews: PreviewProvider {
//    static var previews: some View {
//        UserBar(sideSquareLength: CGFloat(48))
//    }
//}

struct UserBar_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
