import Foundation
import SwiftUI

struct LoginViewOnly: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var loginError: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                LargeLogoOnly()
                Text(loginError)
                TextField("Enter email", text: $email)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                    .autocapitalization(.none)
                SecureField("Enter password", text: $password)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 16, trailing: 0))
                    .autocapitalization(.none)
                                Text("")
                    .foregroundColor(Color(UIColor.systemRed))
                    .font(.custom(fontStyle, size: 18))
                Button(action: {
                    print("Personal Login")
                }){
                    LoginButtonViewOnly()
                }
                Divider()
                    .background(Color(UIColor.black))
                    .frame(width: 300, height: 1)
                    .shadow(color: Color(UIColor.black).opacity(0.04), radius: 3, x: 3, y: 3)
                SignupBarOnly()
                
            }.onAppear(perform: {
            })
        }
            .navigationBarBackButtonHidden(true)
    }
    
    
}

struct LoginViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginViewOnly()
                .environment(\.colorScheme, .dark)
        }
        
        NavigationView {
            LoginViewOnly()
                .environment(\.colorScheme, .light)
        }

    }
}

struct LargeLogoOnly: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 160, height: 160)
                .fixedSize()
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.35), radius: 5, x: 5, y: 7)
            Text("BytePal")
                .font(.custom(fontStyle, size: 32))
                .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.24), radius: 3, x: 3, y: 6)
                .foregroundColor(Color(UIColor.white))
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(red: Double(24)/255.0, green: Double(100)/255.0, blue: Double(196)/255.0))
                        .frame(width: 290, height: 56)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 6, y: 8)
                )
                .padding(16)
        }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16))
    }
}

struct LoginButtonViewOnly: View {
    var body: some View {
        Text("Login")
            .padding(8)
            .font(.custom(fontStyle, size: 20))
            .foregroundColor(Color(UIColor.black))
            .cornerRadius(15)
            .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.64), radius: 3, x: 1, y: 3)
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: 72, height: 30)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.16), radius: 6, x: -2, y: -2)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.white))
                        .frame(width: 72, height: 30)
                        .shadow(color: convertHextoRGB(hexColor: "000000").opacity(0.48), radius: 6, x: 5, y: 5)
                }            )
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
    }
}

struct SignupBarOnly: View {
    var body: some View {
        HStack {
            Text("Register")
                .font(.custom(fontStyle, size: 20))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 48))
            FacebookLoginOnly()
            GoogleLoginOnly()
            PersonalLoginOnly()
        }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 240, trailing: 0))
    }
}


struct FacebookLoginOnly: View {

    var body: some View {
        Button(action: {
            print("Login Facebook")
        }){
            VStack {
                Text("f")
                    .font(.custom(fontStyle, size: 20))
                    .foregroundColor(Color(UIColor.white))
                    .background(
                        Circle()
                            .fill(convertHextoRGB(hexColor: "3B5998"))
                            .frame(width: 32, height: 32)
                            .shadow(color: Color(UIColor.black).opacity(0.48), radius: 4, x: 3, y: 3)
                    )
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 22))
            }
        }
    }
    
    
    
}

struct GoogleLoginOnly: View {
    
    var body: some View {
        VStack {
            Group {
                Button(action: {
                    print("Login Google")
                }){
                    Text("G")
                        .font(.custom(fontStyle, size: 24))
                        .foregroundColor(Color(UIColor.white))
                        .background(
                            Circle()
                                .fill(convertHextoRGB(hexColor: "DB3236"))
                                .frame(width: 32, height: 32)
                                .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                            )
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                }
            }.onAppear(perform: {
            })
        }
    }
}

struct PersonalLoginOnly: View {
    
    var body: some View {
        Image(systemName: "envelope.fill")
            .font(.system(size: 16))
            .foregroundColor(Color(UIColor.white))
            .shadow(color: Color(UIColor.black).opacity(0.32), radius: 6, x: 3, y: 3)
            .background(
                Circle()
                    .fill(convertHextoRGB(hexColor: "1757A8"))
                    .frame(width: 32, height: 32)
                    .shadow(color: Color(UIColor.black).opacity(0.32), radius: 4, x: 3, y: 3)
                )
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 12))
    }
}

