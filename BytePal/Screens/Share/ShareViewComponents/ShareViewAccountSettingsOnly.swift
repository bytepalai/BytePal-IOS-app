//
//  ShareViewAccountSettingsOnly.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ShareViewAccountSettingsOnly: View {
    
    // Arguments
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        VStack(alignment:.leading) {
            Text("Account")
                .foregroundColor(.appFontColorBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ShareViewOnly(height: height!)
            
        }
        .padding(.bottom, 100)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors:
                        [
                            Color.appGreen,
                            Color.appLightGreen
                        ]
            ),
            startPoint: .bottomLeading,
            endPoint: .topLeading
            )
        .blur(radius: 100.0)
        .edgesIgnoringSafeArea(.all))
    }
}
