//
//  ShareBoxView.swift
//  BytePal
//
//  Created by Scott Hom on 11/2/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ShareBoxView: View {
    var width: CGFloat
    @State private var isShareSheetShowing = false
     
    
    var body: some View {
        Button(
            action: shareButton,
            label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color(UIColor.systemBlue))
                    .font(.custom(fontStyle, size: 22))
                    .frame(alignment: .trailing)
                    .padding([.trailing], width*0.025)
            }
        )
    }
    
    func shareButton(){
        isShareSheetShowing.toggle()
        
        let url = URL(string: WEBPAGE_HOSTNAME)
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated:true, completion:nil)
        
    }
}

//struct ShareBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareView()
//            .environment(\.colorScheme, .dark)
//
//        ShareView()
//            .environment(\.colorScheme, .light)
//    }
//}
