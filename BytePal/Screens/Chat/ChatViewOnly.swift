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
                UserBar()
                MessageHistoryOnly()
                    .frame(width: geometry.size.width, height: 700)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ChatViewOnly_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewOnly()
    }
}
#endif
