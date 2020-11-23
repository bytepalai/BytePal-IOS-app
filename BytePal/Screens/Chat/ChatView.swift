//
//  ChatView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct ChatView: View {
    @Binding var rootViewIsActive: Bool
    @EnvironmentObject var userInformation: UserInformation

    var body: some View {
        GeometryReader{ geometry  in
            VStack{
                // User Bar (Size: 6%)
                UserBar(
                    width: geometry.size.width,
                    sideSquareLength: geometry.size.height*0.06,
                    rootViewIsActive: self.$rootViewIsActive
                )
                
                // Space (4%)
                
                // User Bar (Size: 90%)
                MessageHistory(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    rootViewIsActive: self.$rootViewIsActive
                )
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {                
                // Set current view
                userInformation.currentView = "Chat"
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }

}

//#if DEBUG
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//            .environment(\.colorScheme, .dark)
//        
//        ChatView()
//            .environment(\.colorScheme, .light)
//        
//    }
//}
//#endif

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
