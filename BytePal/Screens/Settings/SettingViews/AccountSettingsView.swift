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
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var MessagesCoreDataRead: FetchedResults<Message>
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var isShowingChatView: Bool = false
    var email: String = ""
    @State var name: String = ""
    
    func logout() {
        // Clear user information on logout
        socialMediaAuth.logout(personalLoginStatus: self.userInformation.isLoggedIn)
        for userInformation in UserInformationCoreDataRead {
            moc.delete(userInformation)
        }
        for message in MessagesCoreDataRead {
            moc.delete(message)
        }
        try? self.moc.save()
        
        // Set personal login status to logged out
        let userInformationCoreDataWrite: User = User(context: self.moc)
        userInformationCoreDataWrite.isLoggedIn = false
        try? self.moc.save()
        self.userInformation.isLoggedIn = false

        // Go to Login View
        self.isShowingChatView = true
    }
    
    // Temp
    @State var fullName: String = "ExampleUsername963"
    
    var body: some View {
        VStack {
            
            VStack(alignment:.leading) {
                Text("Account")
                    .foregroundColor(.appFontColorBlack)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Image("profileImage")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(Color.appTranspatentWhite, lineWidth: 5, antialiased: true)  )
                        .shadow(radius: 50)
                    BytePalTextFieldView(title: "Username", textFieldPlaceHolder: "", text: self.$fullName)
                        .disabled(true)

                }
            }
            .padding()
            .padding(.bottom, 100)
            .background(LinearGradient(gradient: Gradient(colors: [Color.appGreen, Color.appLightGreen]), startPoint: .bottomLeading, endPoint: .topLeading)
                            .blur(radius: 100.0)
                            .edgesIgnoringSafeArea(.all))
            
            GeometryReader { proxy in
                List {
                    //TODO: use data arry instead of hardcoded strings and destinations
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            TitleWithSubTitleCell(title: "Email", subTitle: self.userInformation.email)
                        })
//                        TextLink(title: "About", url: "Terms and Conditions")
                    TextLink(title: "Terms and Conditions", url: "Terms and Conditions")
                    TextLink(title: "Privacy Policy", url: "Privacy Policy")
                    
                    
                    Button(action: {
                        logout()
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
            NavigationLink(destination: LoginView().environment(\.managedObjectContext, moc).environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: $isShowingChatView ){EmptyView()}
        }
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
    var title: String
    var url: String
    
    var body: some View {
        NavigationLink(
            destination: self.getWebPage(name: url),
            label: {
                Text(title)
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
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountSettingsView()
                .previewDevice("iPhone 11")
        }
    }
}

