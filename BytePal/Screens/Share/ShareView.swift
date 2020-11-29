//
//  ShareView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 9/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// View that contains the logic for displaying the system share sheet view
struct ShareView: View {
    
    // Arguments
    var height: CGFloat

    // States
    @State private var isShareSheetShowing = false
         
    var body: some View {
        
        // Share button
        HStack{
            
            Image("female user")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.appTranspatentWhite, lineWidth: 5, antialiased: true)  )
                .shadow(radius: 50)
            
            Button(action: {
                
                self.shareButton()
                
            }, label: {
                
                Text("Share")
                    .font(.custom(fontStyle, size: 36))
                    .foregroundColor(Color(UIColor.black))
                
            })
            
            Spacer()
            
        }
            .frame(height: self.height)
        
    }
    
    func shareButton(){
        
        // Set the URL to be shared
        let url = URL(string:"https://www.bytepal.io")
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        // Show the share view
        isShareSheetShowing.toggle()
        
        // Animate the share sheet view appearing
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated:true, completion:nil)
        
    }
}
