//
//  NavigationLinkPopToRootEnvObj.swift
//  BytePal
//
//  Created by Scott Hom on 10/31/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

class NavLinkPopToRoot: ObservableObject {
    @Published var selectedView: String?
}

struct NavigationLinkPopToRootEnvObj: View {
    @EnvironmentObject var navLinkPopToRoot: NavLinkPopToRoot

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    navLinkPopToRoot.selectedView = "ContentView2a"
                }, label: {
                    Text("View2")
                })
                
                NavigationLink(
                    destination: ContentView2a(),
                    tag: "ContentView2a",
                    selection: $navLinkPopToRoot.selectedView
                ) {EmptyView()}
                .navigationBarTitle("Root")
            }
        }
    }
}

struct ContentView2a: View {
    @EnvironmentObject var navLinkPopToRoot: NavLinkPopToRoot

    var body: some View {
        VStack{
            Button(action: {
                navLinkPopToRoot.selectedView = "ContentView3a"
            }, label: {
                Text("View3")
            })
            Button(action: {
                navLinkPopToRoot.selectedView = nil
            }, label: {
                Text("Root")
            })
            
            NavigationLink(
                destination: ContentView3a(),
               tag: "ContentView3a",
               selection: $navLinkPopToRoot.selectedView){EmptyView()}
            .navigationBarTitle("Two")
            
        }
    }
}

struct ContentView3a: View {
    @EnvironmentObject var navLinkPopToRoot: NavLinkPopToRoot

    var body: some View {
        VStack {
            Button(action: {
                navLinkPopToRoot.selectedView = nil
            }, label: {
                Text("Root")
            })
            
        }
    }
}

struct NavigationLinkPopToRootEnvObj_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLinkPopToRootEnvObj()
    }
}
