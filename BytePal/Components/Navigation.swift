//
//  Navigation.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct SettingsNavigation: View {
    var body: some View {
        HStack {
            NavigationLink(destination: AccountSettingsView()) {
                Text("Account")
                    .font(.custom(fontStyle, size: 24))
                    .foregroundColor(convertHextoRGB(hexColor: blueColor))
                    .underline()
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            NavigationLink(destination: ContactSettingsView()) {
                Text("Contact")
                    .font(.custom(fontStyle, size: 24))
                    .foregroundColor(convertHextoRGB(hexColor: blueColor))
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
            .padding(EdgeInsets(top: 64, leading: 64, bottom: 32, trailing: 0))
    }
}

struct NavigationBar: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var userInformation: UserInformation
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                NavigationLink(destination: HomeView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages)){
                    Image(systemName: "house.fill")
                        .font(.system(size: 34))
                        .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 64))
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                }
                
                NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc).environmentObject(userInformation).environmentObject(messages)){
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 34))
                        .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 32, trailing: 0))
                }
                NavigationLink(destination: AccountSettingsView().environment(\.managedObjectContext, moc).environmentObject(userInformation).environmentObject(messages)){
                    Image(systemName: "person.fill")
                        .font(.system(size: 34))
                        .foregroundColor(convertHextoRGB(hexColor: "EAEEED"))
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 3, x: 3, y: 7)
                        .padding(EdgeInsets(top: 0, leading: 64, bottom: 32, trailing: 0))
                }
            }
                .edgesIgnoringSafeArea(.bottom)
                .frame(width: 400, height: 104
            )
                .background(convertHextoRGB(hexColor: "9FA7A3"))
                .shadow(radius: 1).opacity(0.60)
        }
            .edgesIgnoringSafeArea(.bottom)
    }

}
