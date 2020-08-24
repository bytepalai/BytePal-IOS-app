//
//  NavigationProgramatic.swift
//  BytePal
//
//  Created by may on 7/20/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct NavigationProgramatic: View {
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
                VStack {
                    NavigationLink(destination: ChatView(), isActive: $isShowingDetailView) { EmptyView() }
                    Button("Tap to show detail") {
                        self.isShowingDetailView = true
                    }
                }
                .navigationBarTitle("Navigation")
            }
    }
}

struct NavigationProgramatic_Previews: PreviewProvider {
    static var previews: some View {
        NavigationProgramatic()
    }
}
