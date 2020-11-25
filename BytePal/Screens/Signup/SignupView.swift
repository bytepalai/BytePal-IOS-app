//
//  SignupView.swift
//  BytePal AI, LLC
//
//  Created by Scott Hom on 7/17/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI
import CoreData

struct SignupView: View {
    var width: CGFloat?
    var height: CGFloat?
    @Binding var isHiddenLoginView: Bool
    @Binding var isHiddenChatView: Bool
    @Binding var isHiddenSignupView: Bool
    var container: NSPersistentContainer!
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var UserInformationCoreDataRead: FetchedResults<User>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var userInformation: UserInformation
    @EnvironmentObject var messages: Messages
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @ObservedObject var keyboard = KeyboardResponder()
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var isShowingSignupError: Bool = false
    @State var signupError: String = ""
    @State var isShowingChatView: Bool = false
    private let cornerRadious: CGFloat = 8
    private let buttonHeight: CGFloat = 60
    let cornerRadiusTextField: CGFloat = 15.0
    let viewHeightTextField: CGFloat = 75
    let mainViewSpacing: CGFloat = 60
    let textFieldSpace: CGFloat = 30
    let backgroundBlurRadious: CGFloat = 400

    var body: some View {
        
        VStack(alignment: .leading) {
            Button (
                action: {
                    self.isHiddenLoginView = false
                    self.isHiddenSignupView = true
                },
                label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(UIColor.systemBlue))
                            .font(title2Custom)
                        Text("Back")
                            .foregroundColor(Color(UIColor.systemBlue))
                            .font(title2Custom)
                    }
                }
            )
                .padding()
                .isHidden(keyboard.isUp, remove: keyboard.isUp)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack(spacing: textFieldSpace){
                        Text("I am full of thoughts to share with you")
                            .foregroundColor(.appFontColorBlack)
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .isHidden(keyboard.isUp, remove: keyboard.isUp)
                        
                        ZStack {
                            TransparentRoundedBackgroundView(cornerRadius: cornerRadiusTextField)
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.appFontColorBlack)
                                TextField("", text: $email)
                                    .autocapitalization(.none)
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
                                SecureField("Enter password", text: $password)
                                    .autocapitalization(.none)
                            }
                            .padding()
                        }
                        .frame(height: viewHeightTextField, alignment: .center)
                    }
                        .padding()
                    
                    VStack {
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
                        .frame(width: (width ?? CGFloat(200))*0.70, height: 60, alignment: .center)
                            .background(Color.appGreen)
                            .cornerRadius(cornerRadious, antialiased: true)
                            .shadow(radius: 50)
                            .animation(.easeIn)
                    }
                        .alignmentGuide(.leading, computeValue: { _ in ( -((width ?? CGFloat(200)) - (width ?? CGFloat(200))*0.70)/2)})
                    
                }
                
            }
        }
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors:
                            [
                                Color.appLightGreen,
                                Color.appGreen
                            ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .leading
                )
                    .blur(radius: backgroundBlurRadious)
                    .edgesIgnoringSafeArea(.all)
            )
            .frame(width: self.width, height: self.height)
            .onAppear(perform: {
                // Set current view
                userInformation.currentView = "Signup"
            })
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
                    
                    // Init IAP
                    IAPManager.shared.initIAP(userID: userID)

                    // Save user information to cache
                    if UserInformationCoreDataRead.count == 0 {
                        // Is not logged in
                        
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = self.email
                        userInformationCoreDataWrite.firstName = self.firstName
                        userInformationCoreDataWrite.lastName = self.lastName
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    } else if UserInformationCoreDataRead.count > 0 && UserInformationCoreDataRead[0].isLoggedIn == false {
                        // Is logged (After termination)
                        
                        for userInformation in UserInformationCoreDataRead {
                            moc.delete(userInformation)
                        }
                        
                        let userInformationCoreDataWrite: User = User(context: self.moc)
                        userInformationCoreDataWrite.id = userID
                        userInformationCoreDataWrite.email = self.email
                        userInformationCoreDataWrite.firstName = self.firstName
                        userInformationCoreDataWrite.lastName = self.lastName
                        
                        DispatchQueue.main.async {
                            try? self.moc.save()
                        }
                    }
                    
                    // Write user information to RAM
                    DispatchQueue.main.async {
                        self.userInformation.id = userID
                        self.userInformation.email = self.email
                        self.userInformation.firstName = self.firstName
                        self.userInformation.lastName = self.lastName
                        self.userInformation.fullName = self.firstName + " " + self.lastName
                    }

                    // Create agent
                    DispatchQueue.main.async {
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
            self.isShowingSignupError = false
            self.isHiddenLoginView = true
            self.isHiddenSignupView = true
            self.isHiddenChatView = false
        } else {
            print("------- Agent ALREADY created")
        }
    }
}
