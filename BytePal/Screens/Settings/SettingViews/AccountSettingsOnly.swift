import SwiftUI

struct AccountSettingsViewOnly: View {
    var width: CGFloat?
    var height: CGFloat?
    var email: String = ""
    @State var name: String = ""
    @State var fullName: String = "ExampleUsername"
    
    var body: some View {
        VStack {
            // Share button
            ShareViewAccountSettingsOnly(width: width, height: (height ?? CGFloat(500))*0.30)
                
            GeometryReader { proxy in
                List {
                    TitleWithSubTitleCell(title: "Email", subTitle: "example@gmail.com")
                    TextLink(name: "Terms and Conditions")
                    TextLink(name: "Privacy Policy")

                    Button(action: {
                        print("logout")
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
            
            
            NavigationBarOnly(width: (width ?? CGFloat(200)), height: (height ?? CGFloat(400))*0.08, color: Color(UIColor.systemGray3))
            
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("")
            .navigationBarHidden(true)
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

            AccountSettingsViewOnly(width: CGFloat(414),height: CGFloat(800) )
                .environment(\.colorScheme, .light)
        }
    }
}

