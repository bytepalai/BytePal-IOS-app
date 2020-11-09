//
//  PersonalLoginButton.swift
//  BytePal
//
//  Created by may on 11/5/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// PersonalLoginButton (height: 7%)
struct PersonalLoginButton: View {
    var width: CGFloat?
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView: Bool = false
    @Binding var rootViewIsActive: Bool
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenSignupView: Bool
    
    var body: some View {
        
        NavigationLink(destination: SignupView(
            rootViewIsActive: self.$rootViewIsActive,
            isHiddenLoginView: self.$isHiddenLoginView,
            isHiddenSignupView: self.$isHiddenSignupView
        ).environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate))
        {
            
            Image(systemName: "envelope.fill")
                .font(.system(size: 16))
                .foregroundColor(Color(UIColor.white))
                .shadow(color: Color(UIColor.black).opacity(0.32), radius: 6, x: 3, y: 3)
                .background(
                    Circle()
                        .fill(convertHextoRGB(hexColor: "1757A8"))
                        .frame(width: (width ?? CGFloat(100))*0.07 , height: (width ?? CGFloat(100))*0.07)
                        .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                )
                    .padding(EdgeInsets(top: 0, leading: (width ?? CGFloat(100))*0.04, bottom: 0, trailing: (width ?? CGFloat(100))*0.03))
        }
            .isDetailLink(false)
        
        
    }
}

struct PersonalLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
