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
    
    // Arguments
    
    //// View width
    var width: CGFloat
    
    ////  Logo width and height
    var sideSquareLength: CGFloat
    
    var body: some View {
        
        VStack {
            ZStack{
                
                //// Ceneter logo with these spacers
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
