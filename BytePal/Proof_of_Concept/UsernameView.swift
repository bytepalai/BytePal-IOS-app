//
//  UsernameView.swift
//  BytePal
//
//  Created by Scott Hom on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct UsernameView: View {
    var body: some View {
        Text("Username")
            .font(.custom(fontStyle, size: 42))
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
