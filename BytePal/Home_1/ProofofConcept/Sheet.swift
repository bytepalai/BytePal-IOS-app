//
//  Sheet.swift
//  BytePal
//
//  Created by may on 11/9/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import SafariServices

struct SheetView: View {
    @State var isShowingDetail: Bool = false
    var body: some View {
        Button(action: {
            self.isShowingDetail.toggle()
        }, label: {
            Text("Show detail")
        })
            .sheet(
                isPresented: self.$isShowingDetail,
                content: {
                    WebView(url: URL(string: termsAndConditions)!)
                }
            )
    }
}

struct Sheet_Previews: PreviewProvider {
    static var previews: some View {
        SheetView()
    }
}
