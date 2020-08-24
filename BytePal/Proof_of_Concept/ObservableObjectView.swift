//
//  ObservableObjectView.swift
//  BytePal
//
//  Created by may on 8/20/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct ObservableObjectView: View {
    @ObservedObject private var obsvObj = ObsvObj()
    @State var textFieldValue: String = ""
    var body: some View {
        VStack {
            VStack{
                Text("Change Text")
                TextField("Enter text here", text: $textFieldValue)
                Button(action: {
                    self.obsvObj.changeText(text: self.textFieldValue)
                }){
                    Text("Press")
                }
            }
                .padding(16)
            Text("Observable Object: \(obsvObj.text)")
                .padding(16)
        }
        
    }
}

struct ObservableObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObservableObjectView()
    }
}
