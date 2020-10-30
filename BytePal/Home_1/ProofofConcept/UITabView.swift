//
//  UIToolbar.swift
//  BytePal
//
//  Created by may on 10/29/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct TabViewTest: View {
    var body: some View {
        TabView {
            UITabViewSubView1()
                .tabItem {
                    Image(systemName: "house.fill")
                }

            UITabViewSubView2()
                .tabItem {
                    Image(systemName: "bubble.left.fill")
                }
            UITabViewSubView3()
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewTest()
    }
}
