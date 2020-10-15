//
//  Settings.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData

struct AccountSettingsView: View {
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView: Bool = false
    var email: String = ""
    
    func logout() {
        // Clear User ID on Logout
        socialMediaAuth.logout()
        for userInformation in UserInformationCoreDataRead {
            moc.delete(userInformation)
        }
        try? self.moc.save()
        
        // Go to Login View
        self.isShowingChatView = true
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            SettingsNavigation()
            Spacer()
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 38))
                    .foregroundColor(convertHextoRGB(hexColor: "eaeeed"))
                    .shadow(radius: 2)
                NavigationLink(destination: UsernameView()){
                    Text("Invite a Friend")
                        .font(.custom(fontStyle, size: 20))
                        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
                        .foregroundColor(convertHextoRGB(hexColor: greenColor))
                }
                Spacer()
            }
                .padding(EdgeInsets(top: 0, leading: 64, bottom: 32, trailing: 0))
            VStack (alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("User")
                        .font(.custom(fontStyle, size: 20))
                    HStack {
                        Text("Email")
                            .font(.custom(fontStyle, size: 14))
                            .foregroundColor(convertHextoRGB(hexColor: blueColor))
                        Text(userInformation.email)
                            .font(.custom(fontStyle, size: 14))
                    }
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 0))
                }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                VStack(alignment: .leading) {
                    Text("About")
                        .font(.custom(fontStyle, size: 20))
                    NavigationLink(destination: Page(request: URLRequest(url: URL(string: "https://bytepal.io/terms")!))){
                        Text("Terms & Conditions")
                            .font(.custom(fontStyle, size: 14))
                            .foregroundColor(convertHextoRGB(hexColor: blueColor))
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 0))
                    }
                        .foregroundColor(Color(UIColor.systemBlue))
                    NavigationLink(destination: Page(request: URLRequest(url: URL(string: "https://bytepal.io/privacy")!))){
                        Text("Privacy Policy")
                            .font(.custom(fontStyle, size: 14))
                            .foregroundColor(convertHextoRGB(hexColor: blueColor))
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 0))
                    }
                        .foregroundColor(Color(UIColor.systemBlue))
                }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
            }
                .padding(EdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 0))
            Button(action: {
                self.logout()
            }){
                Text("Logout")
                    .font(.custom(fontStyle, size: 16))
                    .foregroundColor(Color(UIColor.systemRed))
                    .padding(EdgeInsets(top: 16, leading: 72, bottom: 16, trailing: 0))
            }
            NavigationLink(destination: LoginView().environment(\.managedObjectContext, moc).environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: $isShowingChatView ){EmptyView()}
            Spacer(minLength: 300)
        }
    }
}

struct SettingsText {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .font(.custom(fontStyle, size: 14))
                .padding(8)
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
