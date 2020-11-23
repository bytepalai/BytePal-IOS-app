//
//  Divider.swift
//  BytePal
//
//  Created by Scott Hom on 11/1/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct DividerCustom: View {
    var color: Color
    var length: Float
    var width: Float
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: CGFloat(length), height: CGFloat(width))
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        Divider()
    }
}
