//
//  TransparentRoundedBackgroundView.swift
//  BytePal
//
//  Created by Scott Hom on 11/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct TransparentRoundedBackgroundView: View {
    var cornerRadius: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(.appTranspatentWhite)
    }
}
