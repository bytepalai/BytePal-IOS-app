//
//  ChatView.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/25/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Speech
import Combine
import CoreData
import GoogleSignIn
import FBSDKLoginKit

struct ChatView: View {
    var relativeSize: ViewRelativeSize = ViewRelativeSize()
    
    var body: some View {
        GeometryReader{ geometry  in
            VStack{
                UserBar()
                MessageHistory()
                    .frame(width: geometry.size.width, height: relativeSize.heightMessageHistoryView)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
#endif
