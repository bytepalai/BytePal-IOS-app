//
//  Navigation.swift
//  BytePal
//
//  Created by Scott Hom on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct NavigationBar: View {
    var width: CGFloat
    var height: CGFloat
    var color: Color
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenAccountSettingsView: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                isHiddenHomeView = false
                isHiddenChatView = true
                isHiddenAccountSettingsView = true
            }, label: {
                Image(systemName: "house.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 64))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
            })
            
            Button(action: {
                isHiddenHomeView = true
                isHiddenChatView = false
                isHiddenAccountSettingsView = true
            }, label: {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 32, trailing: 0))
            })
            
            Button(action: {
                isHiddenHomeView = true
                isHiddenChatView = true
                isHiddenAccountSettingsView = false
            }, label: {
                Image(systemName: "person.fill")
                    .font(.system(size: 34))
                    .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                    .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                    .padding(EdgeInsets(top: 0, leading: 64, bottom: 32, trailing: 0))
            })

        }
            .frame(width: width, height: height)
            .background(convertHextoRGB(hexColor: "9FA7A3"))
            .shadow(radius: 1)
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
