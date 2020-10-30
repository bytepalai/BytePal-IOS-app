//
//  IdentifyDevice.swift
//  BytePal
//
//  Created by may on 10/29/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct IdentifyDevice: View {
    @State var deviceType: String = ""
    
    var body: some View {
        VStack{
            Text("Identify Device")
                .padding(32)
            Text("Type: \(self.deviceType)")
                .padding([.bottom], 32)
            
            Button(action: {
                switch UIDevice().type {
                    case .iPhone12ProMax:
                        print("428 x 926: .iPhone12ProMax")
                        self.deviceType = "428 x 926: .iPhone12ProMax"
                    case .iPhone11ProMax, .iPhoneXSMax, .iPhone11, .iPhoneXR:
                        print("414 x 896: .iPhone11ProMax, .iPhoneXSMax, .iPhone11, .iPhoneXR")
                        self.deviceType = "414 x 896: .iPhone11ProMax, .iPhoneXSMax, .iPhone11, .iPhoneXR"
                    case .iPhone12, .iPhone12Pro:
                        print("390 x 844: .iPhone12, .iPhone12Pro")
                        self.deviceType = "390 x 844: .iPhone12, .iPhone12Pro"
                    case .iPhone11Pro, .iPhoneX, .iPhoneXS:
                        print("375 x 812: .iPhone11Pro, .iPhoneX, .iPhoneXS")
                        self.deviceType = "375 x 812: .iPhone11Pro, .iPhoneX, .iPhoneXS"
                    case .iPhone6SPlus:
                        print("414 x 736: .iPhone6SPlus")
                        self.deviceType = "414 x 736: .iPhone6SPlus"
                    case .iPhone6S:
                        print("375 x 667: .iPhone6S")
                        self.deviceType = "375 x 667: .iPhone6S. \(UIDevice().type)"
                    default:
                        print("default")
                }
            }){
                Text("Get device")
            }
        }
    }
}

//struct IdentifyDevice_Previews: PreviewProvider {
//    static var previews: some View {
//        IdentifyDevice()
//            .environment(\.colorScheme, .light)
//    }
//}
