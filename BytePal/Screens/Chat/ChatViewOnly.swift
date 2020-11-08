//
//  ChatView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatViewOnly: View {
    
    var body: some View {
        GeometryReader{ geometry  in
            VStack{
                // User Bar (Size: 6%)
                UserBarOnly(
                    width: geometry.size.width,
                    sideSquareLength: geometry.size.height*0.06
                )
                .frame(alignment: .bottom)
                
                // Space (4%)
                
                // User Bar (Size: 90%)
                MessageHistoryOnly(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .frame(alignment: .bottom)
            }
            .frame(height: geometry.size.height, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ChatViewOnly_Previews: PreviewProvider {
    static var previews: some View {
//        ChatViewOnly()
//            .environment(\.colorScheme, .dark)
        
        ChatViewOnly()
            .environment(\.colorScheme, .light)
    }
}
#endif
