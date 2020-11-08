//
//  AlignementGuides.swift
//  BytePal
//
//  Created by may on 7/20/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

// Questions
////  - What are the underscores?

import SwiftUI

struct AlignementGuidesView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                LabelView(text: "Apple", color: Color(UIColor.systemRed))
                    .alignmentGuide(.trailing, computeValue: { _ in 50})
                LabelView(text: "Banana", color: Color(UIColor.systemYellow))
                    .alignmentGuide(.trailing, computeValue: { _ in -50})
                LabelView(text: "Canteloup", color: Color(UIColor.systemGreen))
                    .alignmentGuide(.trailing, computeValue: { _ in 50})
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
    }
}

struct LabelView: View {
    var text: String
    var color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: 192, height: 32)
                .cornerRadius(10)
            Text(text)
                .foregroundColor(Color(UIColor.white))
                .padding(16)
        }
    }
}

struct AlignementGuides_Previews: PreviewProvider {
    static var previews: some View {
        AlignementGuidesView()
    }
}
