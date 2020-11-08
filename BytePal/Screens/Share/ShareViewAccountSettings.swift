//
//  ShareViewAccountSettings.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ShareViewAccountSettings: View {
    var width: CGFloat?
    @Binding var rootViewIsActive: Bool
    
    var body: some View {
        VStack(alignment:.leading) {
            
            Text("Account")
                .foregroundColor(.appFontColorBlack)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ShareView(
                height: (width ?? CGFloat(50))*0.30,
                rootViewIsActive: self.$rootViewIsActive
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

//struct ShareViewAccountSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareViewAccountSettings()
//    }
//}
