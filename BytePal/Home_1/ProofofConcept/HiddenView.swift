//
//  HiddenView.swift
//  BytePal
//
//  Created by may on 11/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct HiddenView: View {
    @State var isShowingView1: Bool = false
    @State var isShowingView2: Bool = true
    
    var body: some View {
        VStack {
            Text("View 1")
                .border(Color(UIColor.black), width: 1)
                .isHidden(self.isShowingView1, remove: self.isShowingView1)
            Text("View 2")
                .border(Color(UIColor.black), width: 1)
                .isHidden(self.isShowingView2, remove: self.isShowingView2)
            Button(action: {
                isShowingView1.toggle()
                isShowingView2.toggle()
            },
            label: {
                Text("Toggle Views")
            })
        }
            .border(Color(UIColor.black), width: 2)
        
    }
}

struct HiddenView_Previews: PreviewProvider {
    static var previews: some View {
        HiddenView()
    }
}
