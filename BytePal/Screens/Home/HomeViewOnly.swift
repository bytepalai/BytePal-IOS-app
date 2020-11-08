import SwiftUI

struct HomeViewOnly: View {
    var number: NumberController = NumberController()
    var width: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    ScrollView {
                        VStack {
                            CompanyLogo()
                            UpgradeButtonOnly()
                            MessageCellScrollViewOnly()
                        }
                    }
                }
                VStack {
                    Spacer()
                    NavigationBarOnly(
                        width: geometry.size.width,
                        height: geometry.size.height*0.10,
                        color: convertHextoRGB(hexColor: "9FA7A3")
                    )
                        .frame(width: geometry.size.width, height: 104)
                }
            }
            
        }
            .edgesIgnoringSafeArea(.bottom)
    }
    
    // Unique Device Identifier by width in points
}

struct CompanyLogoOnly: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: height, alignment: .center)
            
            Text("BytePal")
                .fontWeight(.bold)
                .font(Font.system(size: height * 0.75))
                .foregroundColor(.appFontColorBlack)
        }
    }
    
        let height: CGFloat = 75
}

struct UpgradeButtonOnly: View {
    var messagesLeftAmount: String = "9,350 / 10,000"
    @EnvironmentObject var deviceInfo: DeviceInfo
    
    var body: some View {
        Group {
                HStack {
                    Spacer()
                    VStack {
                        Text("Messages left")
                            .bold()
                        Text(messagesLeftAmount)
                            .bold()
                        Button(action: {
                            print("Go to IAP View")
                        }) {
                            Text("Upgrade")
                                .font(.title)
                                .foregroundColor(.appGreen)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                        .font(title2Custom)
                        .foregroundColor(.gray)
                    Spacer()
                }
                    .padding()
                    .background(Color.appLightGray)
                    .cornerRadius(10)
                    .shadow(color: .appGreen, radius: 1, x: 0, y: 0)
                    .padding()
                    
        }
        .onAppear(perform: {
            self.deviceInfo.setDeviceGroup()
        })
    }
}

struct MessageCellScrollViewOnly: View {

    var body: some View {
        ScrollView {
            VStack {
                
                HomeMessageCellOnly(messageCreator: .user(message: "Good morning!"))
                HomeMessageCellOnly(messageCreator: .bytePal(message: "It is a beautiful day. I like walking my dog along the marina. How about you?"))
                
            }
        }
    }
}


struct HomeOnly_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeViewOnly()
                .environmentObject(DeviceInfo())
                .environment(\.colorScheme, .dark)
                
        }
        
        NavigationView {
            HomeViewOnly()
                .environmentObject(DeviceInfo())
                .environment(\.colorScheme, .light)
                
        }
        
    }
}
