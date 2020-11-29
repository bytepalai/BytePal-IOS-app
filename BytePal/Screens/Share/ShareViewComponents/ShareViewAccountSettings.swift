//
//  ShareViewAccountSettings.swift
//  BytePal
//
//  Created by Scott Hom on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// ShareView for the AccountSettingsView
struct ShareViewAccountSettings: View {
    
    // Arguments
    var width: CGFloat?
    
    var body: some View {
        VStack(alignment:.leading) {
            
            Text("Account")
                .foregroundColor(.appFontColorBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // View that contains the logic for displaying the system share sheet view
            ShareView(
                height: (width ?? CGFloat(50))*0.30
            )
            
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
