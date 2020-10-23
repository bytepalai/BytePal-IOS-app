//
//  SignupView.swift
//  BytePal AI, LLC
//
//  Created by may on 7/17/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI
import CoreData

struct SignupView: View {
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var signupError: String = ""
    @State var isShowingChatView: Bool = false
    private let cornerRadious: CGFloat = 8
    private let buttonHeight: CGFloat = 60
    let cornerRadiusTextField: CGFloat = 15.0
    let viewHeightTextField: CGFloat = 75

    func createAgent(id: String) {
            var err: Int = 0
            let semaphore = DispatchSemaphore (value: 0)
            let createAgentParameter = """
            {
                \"user_id\" : "\(id)"
            }
            """

            let postData = createAgentParameter.data(using: .utf8)
            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData

            struct createAgentStruct: Decodable {
                var user_id: String
            }

            // promise han dler (completion handler in Apple Dev Doc)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
                    // Parse response
                    let dataResponse: String = String(data: data, encoding: .utf8)!
                    if dataResponse != "New Agent created" {
                        err = 1
                    }
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()

            if err == 0 {
                self.isShowingChatView = true
            } else {
                print("------- Agent ALREADY created")
            }
    }

    func signup () {
            let semaphore = DispatchSemaphore (value: 0)
            let parameters = """
            {
                \"email\": \"\(self.email)\",
                \"password\": \"\(self.password)\",
                \"first_name\": \"\(self.firstName)\",
                \"last_name\": \"\(self.lastName)\"
            }
            """
            let postData = parameters.data(using: .utf8)

            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/register")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            struct responseStruct: Decodable {
                var user_id: String
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do {
                    if String(data: data, encoding: .utf8)! == "User Email already Exist" {
                        self.signupError = "User is already signed up"
                    } else {
                        // Set user id
                        let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
                        let userID: String = reponseObject.user_id

                        // Write user information to cache
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = self.email
                        userInformationCoreDataWrite.firstName = self.firstName
                        userInformationCoreDataWrite.lastName = self.lastName

                        DispatchQueue.global(qos: .background).async {
                            try? self.moc.save()
                        }

                        // Write user information to RAM

                        DispatchQueue.main.async {
                            self.userInformation.id = userID
                            self.userInformation.email = self.email
                            self.userInformation.firstName = self.firstName
                            self.userInformation.lastName = self.lastName
                            self.userInformation.fullName = self.firstName + " " + self.lastName
                        }

                        DispatchQueue.global(qos: .userInitiated).async {
                            self.createAgent(id: userID)
                        }
                    }
                } catch {
                    print(error)
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
    
    var body: some View {
    
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading,spacing: mainViewSpacing) {

                Text("I am full of thoughts to share with you")
                    .foregroundColor(.appFontColorBlack)
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: textFieldSpace){
                    ZStack {
                        TransparentRoundedBackgroundView(cornerRadius: cornerRadiusTextField)
                        VStack(alignment: .leading) {
                            Text("Email")
                                .fontWeight(.semibold)
                                .foregroundColor(.appFontColorBlack)
                            TextField("", text: $email)
                        }
                        .padding()
                    }
                    .frame(height: viewHeightTextField, alignment: .center)
                    ZStack {
                        TransparentRoundedBackgroundView(cornerRadius: cornerRadiusTextField)
                        VStack(alignment: .leading) {
                            Text("First Name")
                                .fontWeight(.semibold)
                                .foregroundColor(.appFontColorBlack)
                            TextField("", text: $firstName
                            )
                        }
                        .padding()
                    }
                    .frame(height: viewHeightTextField, alignment: .center)
                    ZStack {
                        TransparentRoundedBackgroundView(cornerRadius: cornerRadiusTextField)
                        VStack(alignment: .leading) {
                            Text("Last Name")
                                .fontWeight(.semibold)
                                .foregroundColor(.appFontColorBlack)
                            TextField("", text: $lastName)
                        }
                        .padding()
                    }
                    .frame(height: viewHeightTextField, alignment: .center)
                    ZStack {
                        TransparentRoundedBackgroundView(cornerRadius: cornerRadiusTextField)
                        VStack(alignment: .leading) {
                            Text("Password")
                                .fontWeight(.semibold)
                                .foregroundColor(.appFontColorBlack)
                            TextField("", text: $password)
                        }
                        .padding()
                    }
                    .frame(height: viewHeightTextField, alignment: .center)
                }
                .zIndex(1.0)
                
                Button(action: {
                    if self.email != "" && self.firstName != "" && self.lastName != "" && self.password != "" {
                            self.signup()
                    }
                    else {
                        self.signupError = "Error missing signup field"
                    }
                }, label: {
                    Text("Signup")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                })
                    .frame(width: 300, height: 60, alignment: .center)
                    .background(Color.appGreen)
                    .cornerRadius(cornerRadious, antialiased: true)
                    .shadow(radius: 50)
                    .animation(.easeIn)
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.appLightGreen, Color.appGreen]), startPoint: .topLeading, endPoint: .leading)
                        .blur(radius: backgroundBlurRadious)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
        NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$isShowingChatView){EmptyView()}
    }
    
    //MARK: Constant
    let mainViewSpacing: CGFloat = 60
    let textFieldSpace: CGFloat = 30
    let backgroundBlurRadious: CGFloat = 400
}

//struct SignupView: View {
//    var container: NSPersistentContainer!
//    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreData: FetchedResults<User>
//    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var userInformation: UserInformation
//    @EnvironmentObject var messages: Messages
//    @EnvironmentObject var googleDelegate: GoogleDelegate
//    @State var email: String = ""
//    @State var firstName: String = ""
//    @State var lastName: String = ""
//    @State var password: String = ""
//    @State var signupError: String = ""
//    @State var isShowingChatView: Bool = false
//
//    func createAgent(id: String) {
//            var err: Int = 0
//            let semaphore = DispatchSemaphore (value: 0)
//            let createAgentParameter = """
//            {
//                \"user_id\" : "\(id)"
//            }
//            """
//
//            let postData = createAgentParameter.data(using: .utf8)
//            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/create_agent")!,timeoutInterval: Double.infinity)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            request.httpBody = postData
//
//            struct createAgentStruct: Decodable {
//                var user_id: String
//            }
//
//            // promise han dler (completion handler in Apple Dev Doc)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print(String(describing: error))
//                    return
//                }
//                do {
//                    // Parse response
//                    let dataResponse: String = String(data: data, encoding: .utf8)!
//                    if dataResponse != "New Agent created" {
//                        err = 1
//                    }
//                }
//                semaphore.signal()
//            }
//            task.resume()
//            semaphore.wait()
//
//            if err == 0 {
//                self.isShowingChatView = true
//            } else {
//                print("------- Agent ALREADY created")
//            }
//    }
//
//    func signup () {
//            let semaphore = DispatchSemaphore (value: 0)
//            let parameters = """
//            {
//                \"email\": \"\(self.email)\",
//                \"password\": \"\(self.password)\",
//                \"first_name\": \"\(self.firstName)\",
//                \"last_name\": \"\(self.lastName)\"
//            }
//            """
//            let postData = parameters.data(using: .utf8)
//
//            var request = URLRequest(url: URL(string: "\(API_HOSTNAME)/register")!,timeoutInterval: Double.infinity)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            request.httpBody = postData
//            struct responseStruct: Decodable {
//                var user_id: String
//            }
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print(String(describing: error))
//                    return
//                }
//                do {
//                    if String(data: data, encoding: .utf8)! == "User Email already Exist" {
//                        self.signupError = "User is already signed up"
//                    } else {
//                        // Set user id
//                        let reponseObject = try JSONDecoder().decode(responseStruct.self, from: data)
//                        let userID: String = reponseObject.user_id
//
//                        // Write user information to cache
//                        let userInformationCoreDataWrite: User = User(context: self.moc)
//                        userInformationCoreDataWrite.id = userID
//                        userInformationCoreDataWrite.email = self.email
//                        userInformationCoreDataWrite.firstName = self.firstName
//                        userInformationCoreDataWrite.lastName = self.lastName
//
//                        DispatchQueue.global(qos: .background).async {
//                            try? self.moc.save()
//                        }
//
//                        // Write user information to RAM
//
//                        DispatchQueue.main.async {
//                            self.userInformation.id = userID
//                            self.userInformation.email = self.email
//                            self.userInformation.firstName = self.firstName
//                            self.userInformation.lastName = self.lastName
//                            self.userInformation.fullName = self.firstName + " " + self.lastName
//                        }
//
//                        DispatchQueue.global(qos: .userInitiated).async {
//                            self.createAgent(id: userID)
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
//                semaphore.signal()
//            }
//            task.resume()
//            semaphore.wait()
//        }
//
//    var body: some View {
//        NavigationView {
//            VStack (alignment: .leading) {
//                    Group {
//                        Text("Signup")
//                            .font(.custom(fontStyle, size: 32))
//                            .padding(EdgeInsets(top: 150, leading: 125, bottom: 32, trailing: 125))
//                        Text(self.signupError)
//                            .font(.custom(fontStyle, size: 16))
//                            .foregroundColor(Color(UIColor.systemRed))
//                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
//                        Text("Email Address")
//                            .font(.custom(fontStyle, size: 16))
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
//                        TextField("myemail@domain.com", text: $email)
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
//                            .autocapitalization(.none)
//                        Text("First Name")
//                            .font(.custom(fontStyle, size: 16))
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
//                        TextField("First Name", text: $firstName)
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
//                        Text("Last Name")
//                            .font(.custom(fontStyle, size: 16))
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
//                        TextField("First Name", text: $lastName)
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
//                        Text("Password")
//                            .font(.custom(fontStyle, size: 16))
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
//                        SecureField("Enter Password", text: $password)
//                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
//                    }
//                    Button(action: {
//
//                        if self.email != "" && self.firstName != "" && self.lastName != "" && self.password != "" {
//                                self.signup()
//                        }
//                        else {
//                            self.signupError = "Error missing signup field"
//                        }
//                    }){
//                        Text("Signup")
//                    }
//                        .padding(EdgeInsets(top: 0, leading: 160, bottom: 256, trailing: 160))
//                NavigationLink(destination: ChatView().environment(\.managedObjectContext, moc) .environmentObject(userInformation).environmentObject(messages).environmentObject(googleDelegate), isActive: self.$isShowingChatView){EmptyView()}
//                    Spacer(minLength: 320)
//            }
//        }
//    }
//}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
