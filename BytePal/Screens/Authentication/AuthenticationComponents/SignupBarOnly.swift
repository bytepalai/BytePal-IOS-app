//
//  SignupBarOnly.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// SignupBar (height: 40%)
struct SignupBarOnly: View {
    
    // Arguments
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        HStack {
            
            // SignupBar (height: 10%, heighest is TextView)
            FacebookLoginButtonOnly(width: width, height: height)
            GoogleLoginButtonOnly(width: width, height: height)
            PersonalLoginButtonOnly(width: width, height: height)
            
//            AppleLoginButtonViewOnly()
            
            
        }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: (height ?? CGFloat(200))*0.30, trailing: 0))
    }
}

struct SignupBarOnly_Previews: PreviewProvider {
    static var previews: some View {
        SignupBarOnly(
            width: CGFloat(414),
            height: CGFloat(800)
        )
    }
}
