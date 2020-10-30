//
//  ShareView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 9/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ShareView: View {
    
    @State private var isShareSheetShowing = false
    
    var body: some View {
        Button(action:shareButton){
            Image(systemName: "square.and.arrow.up")
                .font(.largeTitle)
        }
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
        ShareView()
            .environment(\.colorScheme, .dark)
        
        ShareView()
            .environment(\.colorScheme, .light)
    }
}
