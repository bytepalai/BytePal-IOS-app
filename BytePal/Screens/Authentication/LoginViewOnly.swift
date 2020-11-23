import Foundation
import SwiftUI

struct LoginViewOnly: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loginError: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // LargeLogo (height: 41%)
                Group(){
                    LargeLogo(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    Text(loginError)
                }
                Group(){
                    TextField("Enter email", text: $email)
                        .padding(EdgeInsets(top: 0, leading: geometry.size.width*0.04, bottom: geometry.size.width*0.02, trailing: 0))
                        .autocapitalization(.none)
                    SecureField("Enter password", text: $password)
                        .padding(EdgeInsets(top: 0, leading: geometry.size.width*0.04, bottom: geometry.size.width*0.02, trailing: 0))
                        .autocapitalization(.none)
                                    Text("")
                        .foregroundColor(Color(UIColor.systemRed))
                        .font(.custom(fontStyle, size: 18))
                    
                    // LargeLogo (height: 9%)
                    
                }
                
                Divider()
                    .background(Color(UIColor.black))
                    .frame(width: geometry.size.width*0.75, height: 1)
                    .shadow(color: Color(UIColor.black).opacity(0.04), radius: 3, x: 3, y: 3)
                
                SignupBarOnly(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                
            }
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct LoginViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginViewOnly()
                .environment(\.colorScheme, .light)
        }
    }
}

