//
//  AppleLoginView.swift
//  BytePal
//
//  Created by Scott Hom on 11/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import UIKit
import SwiftUI

struct AppleLoginButtonViewOnly: View {

    var body: some View {

        Button(action: {
            print("Display Applep Login")
        }, label: {
            Image("White Logo Square")
                .frame(width: CGFloat(37), height: CGFloat(37))
                .clipShape(Circle())
                .shadow(color: Color(UIColor.black).opacity(0.80), radius: 4, x: 2, y: 2)
        })
            .buttonStyle(PlainButtonStyle())
        
    }
    
}

struct AppleLoginButtonViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButtonViewOnly()
    }
}

