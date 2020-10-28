import SwiftUI

struct AccountSettingsViewOnly: View {
    var email: String = ""
    @State var name: String = ""
    @State var fullName: String = "ExampleUsername"
    
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
                                        NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            TitleWithSubTitleCellOnly(title: "Email", subTitle: "example@domain.com")
                        })
                    TextLinkOnly(title: "Terms and Conditions", url: "Terms and Conditions")
                    TextLinkOnly(title: "Privacy Policy", url: "Privacy Policy")
                    
                    
                    Button(action: {
                        print("Logout")
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
        }
    }
}

struct TitleWithSubTitleCellOnly: View {
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

struct TextLinkOnly: View {
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

extension TextLinkOnly {
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

struct AccountSettingsViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountSettingsViewOnly()
                .previewDevice("iPhone 11")
        }
    }
}

