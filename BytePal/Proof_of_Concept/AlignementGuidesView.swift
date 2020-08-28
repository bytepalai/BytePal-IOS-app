//
//  AlignementGuides.swift
//  BytePal
//
//  Created by may on 7/20/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct AlignementGuidesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Banana")
            Text("Banana")
                .alignmentGuide(.leading){d in d[.trailing]}
            Text("Apple")
                .alignmentGuide(.trailing){d in d[.leading]}
            Text("Banana")
//            Text("Canteloup")
        }
            .border(Color.black, width: 2)
    }
}

struct AlignementGuides_Previews: PreviewProvider {
    static var previews: some View {
        AlignementGuidesView()
    }
}
