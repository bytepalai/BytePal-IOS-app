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
    let width: CGFloat?
    let height: CGFloat?
    @Binding var rootViewIsActive: Bool
    @Binding var isHiddenHomeView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenAccountSettingsView: Bool
    var socialMediaAuth: SocialMediaAuth = SocialMediaAuth()
    var container: NSPersistentContainer!
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @State var isShowingChatView: Bool = false
    var email: String = ""
    @State var name: String = ""

    // Temp
    @State var fullName: String = "ExampleUsername963"
    
    
    var body: some View {
        
        VStack {
            
            // Share button
            ShareViewAccountSettings(
                width: (width ?? 100),
                rootViewIsActive: self.$rootViewIsActive
            )
                
            GeometryReader { proxy in
                List {
                    TitleWithSubTitleCell(title: "Email", subTitle: self.userInformation.email)
                    TextLink(name: "Terms and Conditions")
                    TextLink(name: "Privacy Policy")

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
            
            NavigationBar(
                width: width!,
                height: height!*0.10,
                color: Color(UIColor.systemGray3),
                rootViewIsActive: self.$rootViewIsActive,
                isHiddenHomeView: self.$isHiddenHomeView,
                isHiddenChatView: self.$isHiddenChatView,
                isHiddenAccountSettingsView: self.$isHiddenAccountSettingsView
            )
        }
            .onAppear(perform: {
                // Set current view
                self.userInformation.currentView = "AccountSettings"
            })
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
        self.userInformation.firstName = ""
        self.userInformation.lastName = ""
        
        //// Messages
        self.messages.list = [[String: Any]]()
        self.messages.messagesLeft = -1
        self.messages.lastMessages = [String]()
        
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
        self.rootViewIsActive = false

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
