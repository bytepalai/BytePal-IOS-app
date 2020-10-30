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
    @State var heightMessageHistory: CGFloat = CGFloat(0.0)
    var relativeSize: ViewRelativeSize = ViewRelativeSize()
    
    var body: some View {
        GeometryReader{ geometry  in
            ZStack {
                UserBar()
                    .zIndex(1)
                MessageHistoryOnly()
                    .frame(width: geometry.size.width, height: relativeSize.heightMessageHistoryView)
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .zIndex(0)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    func setHeightMessageHistory(height: CGFloat) {
        self.heightMessageHistory = height
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
