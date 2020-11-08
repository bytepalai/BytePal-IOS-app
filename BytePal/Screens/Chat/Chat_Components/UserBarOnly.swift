//
//  UserBarOnly.swift
//  BytePal
//
//  Created by may on 11/2/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct UserBarOnly: View {
    var width: CGFloat
    var sideSquareLength: CGFloat
    
    var body: some View {
        VStack {
            ZStack{
                
                // Logo
                VStack {
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
                
                // Logout button
                HStack {
                    
                    Spacer()
                    
                    ShareBoxView(width: width)
                    
                    Button(action: {
                        print("Logout")
                    }, label: {
                        HStack {
                            Text("Logout")
                                .font(.custom(fontStyle, size: 18))
                                .foregroundColor(Color(UIColor.systemBlue))
                                
                            Image(systemName: "chevron.right")
                                .font(.custom(fontStyle, size: 18))
                                .foregroundColor(Color(UIColor.systemBlue))
                            
                        }
                    })
                        .frame(alignment: .trailing)
                }
                .frame(width: width, alignment: .trailing)
                    .padding([.trailing], 16)
                    
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
        .padding([.top], 60)
    }
}

struct UserBarOnly_Previews: PreviewProvider {
    static var previews: some View {
        UserBarOnly(width: 414, sideSquareLength: 48)
    }
}
