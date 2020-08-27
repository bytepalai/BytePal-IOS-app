//
//  TestWav.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import SwiftUI

// Swift UI View to Play the Wav Files
struct TestWav: View {
    var body: some View {
    Button(action: {
        Sounds.playSounds(soundfile: "flowtron_v2.wav")

    }) {Text("Sing")
        }
}
}

struct TestWav_Previews: PreviewProvider {
    static var previews: some View {
        TestWav()
    }
}
