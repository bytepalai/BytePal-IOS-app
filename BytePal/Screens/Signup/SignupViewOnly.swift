import SwiftUI
import CoreData

struct SignupViewOnly: View {
    var container: NSPersistentContainer!
    private let cornerRadious: CGFloat = 8
    private let buttonHeight: CGFloat = 60
    let cornerRadiusTextField: CGFloat = 15.0
    let viewHeightTextField: CGFloat = 75
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var signupError: String = ""
    let mainViewSpacing: CGFloat = 60
    let textFieldSpace: CGFloat = 30
    let backgroundBlurRadious: CGFloat = 400
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Button(action: {
                    print("Back")
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(UIColor.systemBlue))
                            .font(title2Custom)
                        Text("Back")
                            .foregroundColor(Color(UIColor.systemBlue))
                            .font(title2Custom)
                    }
                })
                    .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading,spacing: mainViewSpacing) {
                        VStack(spacing: textFieldSpace){
                            Text("I am full of thoughts to share with you")
                                .foregroundColor(.appFontColorBlack)
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                            
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
                            .padding()
                        
                        VStack {
                            Button(action: {
                                if self.email != "" && self.firstName != "" && self.lastName != "" && self.password != "" {
                                        print("signup")
                                }
                                else {
                                    self.signupError = "Error missing signup field"
                                }
                            }, label: {
                                Text("Signup")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            })
                            .frame(width: geometry.size.width*0.70, height: 60, alignment: .center)
                                .background(Color.appGreen)
                                .cornerRadius(cornerRadious, antialiased: true)
                                .shadow(radius: 50)
                                .animation(.easeIn)
                        }
                            .alignmentGuide(.leading, computeValue: { _ in ( -(geometry.size.width - geometry.size.width*0.70)/2)})
                        
                    }
                    
                }
            }
                .background(LinearGradient(gradient: Gradient(colors: [Color.appLightGreen, Color.appGreen]), startPoint: .topLeading, endPoint: .leading)
                            .blur(radius: backgroundBlurRadious)
                            .edgesIgnoringSafeArea(.all))
        }

    }
}


struct SignUpViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        SignupViewOnly()
    }
} 
