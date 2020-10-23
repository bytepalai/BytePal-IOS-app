//
//  ButtonStyles.swift
//  BytePal
//
//  Created by Heshan Yodagama on 10/13/20.
//

import SwiftUI

struct TransparentBackgroundButtonStyle: ButtonStyle {
    init(backgroundColor: Color,cornerRadious: CGFloat = 0) {
        self.backgroundColor = backgroundColor
        self.cornerRadious = cornerRadious
    }
    
    var backgroundColor: Color
    var cornerRadious: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .opacity(0.8)
                .cornerRadius(cornerRadious)
            configuration.label
                .opacity( configuration.isPressed ? 0.2:1)
        }
        
    }
    
}

struct WidthStrechyBackgroundButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
            HStack {
                Spacer()
                configuration.label
                    .opacity( configuration.isPressed ? 0.2:1)
                Spacer()
            }
            .background(backgroundColor)
    }
    
}
