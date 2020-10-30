//
//  DarkMode.swift
//  BytePal
//
//  Created by may on 10/30/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct DarkMode: View {
    @Environment(\.colorScheme) var colorScheme
    var colorSchemeString: String = ""
    
    init() {
        colorSchemeString = colorScheme == .dark ? "Dark Mode" : "Light Mode"
    }
    var body: some View {
        VStack() {
            Text("Color Scheme")
            Text("Type: \(colorSchemeString)")
        }
    }
}

struct DarkMode_Previews: PreviewProvider {
    static var previews: some View {
        DarkMode()
            .environment(\.colorScheme, .dark)
        
        DarkMode()
            .environment(\.colorScheme, .light)
    }
}
