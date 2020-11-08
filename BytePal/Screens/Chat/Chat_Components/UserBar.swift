//
//  UserBar.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI
import CoreData

//  User Inforamtion Bar (Top)
struct UserBar: View {
    // UserBar View
    var width: CGFloat
    var sideSquareLength: CGFloat
    
    // AccountSettings View
    @Binding var rootViewIsActive: Bool
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
    // Temp
    @State var fullName: String = "ExampleUsername963"
    
    var body: some View {
        
        VStack {
            ZStack{
                
                Spacer()
                
                // Logo
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: sideSquareLength, height: sideSquareLength)
                        .frame(alignment: .center)
                }
                    .frame(
                        width: width,
                        height: sideSquareLength,
                        alignment: .center
                    )
                    .padding([.bottom], 8)
                
                Spacer()
                    
            }
                
            DividerCustom(
                color: Color(UIColor.systemGray3),
                length: Float(width),
                width: 1
            )
                .shadow(color: Color(UIColor.systemGray), radius: 1, x: 0, y: 1)
        }
            .frame(
                width: width,
                height: sideSquareLength,
                alignment: .center
            )
    }
    
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
        
        // Clear Environment Object
        //// User info
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
        try? self.moc.save()
        self.userInformation.isLoggedIn = false
        self.rootViewIsActive = false
        
    }
    
}

//struct UserBar_Previews: PreviewProvider {
//    static var previews: some View {
//        UserBar(sideSquareLength: CGFloat(48))
//    }
//}

struct UserBar_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
