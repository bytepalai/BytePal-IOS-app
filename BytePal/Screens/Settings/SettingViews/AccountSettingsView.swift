//
//  Settings.swift
//  BytePal
//
//  Created by Scott Hom on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import CoreData

struct AccountSettingsView: View {
    
    // Arguments
    
    let width: CGFloat?
    let height: CGFloat?
    
    // Constats
    var email: String = ""
    
    //// Contorl which view is beign shown
    @Binding var isHiddenUserBar: Bool
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenAccountSettingsView: Bool
    
    // BytePal Objects
    
    //// Controller indicate sign in status
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()
    
    
    
    // Core Data
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    
    // Environment Object
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    
    // States
    @State var isShowingChatView: Bool = false
    @State var name: String = ""

    var body: some View {
        
        VStack {
            
            // Share button
            ShareViewAccountSettings(width: (width ?? 100))
                
            GeometryReader { proxy in
                
                // Settigns
                List {
                    
                    // User email
                    TitleWithSubTitleCell(title: "Email", subTitle: self.userInformation.email)
                    
                    // Terms and conditions
                    TextLink(name: "Terms and Conditions")
                    
                    // Privacy Policy
                    TextLink(name: "Privacy Policy")
                    
                    // Logout button
                    Button(action: {
                        self.logout()
                    }, label: {
                        Text("Logout")
                            .foregroundColor(.darkRed)
                            .fontWeight(.bold)
                    })
                        .buttonStyle(TransparentBackgroundButtonStyle(backgroundColor: .appLightGray))
                        .frame(height: 50, alignment: .center)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding()
                    
                }
                .frame(width: proxy.size.width - 20, height: proxy.size.height + proxy.size.height/10, alignment: .center)
                .cornerRadius(20, antialiased: true)
                .shadow(radius: 0.5)
                .offset(x: 10, y: -proxy.size.height/6)
            }
                .background(Color.appLightGray)
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    print("------ email(AccountSettings): \(self.userInformation.email)")
                })
            
            NavigationBar(
                width: width!,
                height: height!*0.10,
                isHiddenHomeView: self.$isHiddenHomeView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
            )
            
        }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        
    }
    
    func logout() {
        // Set all other account logout status
        socialMediaAuth.logout(personalLoginStatus: self.userInformation.isLoggedIn)
        
        // Clear user information on logout
        for userInformation in UserInformationCoreDataRead {
            moc.delete(userInformation)
        }
        for message in MessagesCoreDataRead {
            moc.delete(message)
        }
        DispatchQueue.main.async {
            try? self.moc.save()
        }

        // Clear Environment Object
        self.userInformation.id = ""
        self.userInformation.email = ""
        self.userInformation.givenName = ""
        self.userInformation.familyName = ""
        
        //// Messages
        self.messages.list = [[String: Any]]()
        self.messages.messagesLeft = -1
        
        // Set personal login status to logged out
        let userInformationCoreDataWrite: User = User(context: self.moc)
        userInformationCoreDataWrite.isLoggedIn = false
        DispatchQueue.main.async {
            try? self.moc.save()
        }
        for userInfo in UserInformationCoreDataRead {
            print("------------ LOGOUT (status): \(userInfo.isLoggedIn)")
        }
        self.userInformation.isLoggedIn = false
        
        // Got Login View
        self.isHiddenUserBar = true
        self.isHiddenHomeView = true
        self.isHiddenChatView = true
        self.isHiddenAccountSettingsView = true
        self.isHiddenLoginView = false
        

    }

}

//MARK: Extracted Views
struct TitleWithSubTitleCell: View {
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 10) {
            Text(title)
                .bold()
            Text(subTitle)
        }
        .padding([.top, .bottom], 20)
    }
}

struct TextLink: View {
    var name: String
    @State var isShowingDetail: Bool = false
    
    var body: some View {
        Button(action: {
            self.isShowingDetail.toggle()
        }, label: {
            Text(name)
        })
            .sheet(
                isPresented: self.$isShowingDetail,
                content: {
                    WebView(url: URL(string: self.getWebURL(name: name))!)
                }
            )
            .padding([.top, .bottom], 20)
    }
}

extension TextLink {
    func getWebPage(name: String) -> Page{
        var url: String = ""
        
        if name == "Terms and Conditions" {
            url = termsAndConditions
        } else if name == "Privacy Policy" {
            url = privacyPolicy
        } else {
            url = "Error"
        }
        
        return Page(request: URLRequest(url: URL(string: url)!))
    }
    
    func getWebURL(name: String) -> String{
        var url: String = ""
        
        if name == "Terms and Conditions" {
            url = termsAndConditions
        } else if name == "Privacy Policy" {
            url = privacyPolicy
        } else {
            url = "Error"
        }
        
        return url
    }
}

//struct AccountSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AccountSettingsView()
//        }
//    }
//}
//
