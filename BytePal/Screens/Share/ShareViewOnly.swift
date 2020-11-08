//
//  ShareViewOnly.swift
//  BytePal
//
//  Created by Paul Ngouchet on 9/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ShareViewOnly: View {
    var height: CGFloat
    @State private var isShareSheetShowing = false
     
    
    var body: some View {
        HStack{
            Image("female user")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.appTranspatentWhite, lineWidth: 5, antialiased: true)  )
                .shadow(radius: 50)
            
            Button(action:shareButton){
                Text("Share")
                    .font(.custom(fontStyle, size: 36))
                    .foregroundColor(Color(UIColor.black))
            }
            
            Spacer()
        }
            .frame(height: self.height)
    }
    
    func shareButton(){
        isShareSheetShowing.toggle()
        
        let url = URL(string:"https://apple.com")
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated:true, completion:nil)
        
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareViewOnly(height: 414)
            .environment(\.colorScheme, .dark)

    }
}
