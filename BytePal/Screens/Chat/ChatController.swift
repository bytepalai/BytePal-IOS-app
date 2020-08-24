//
//  ChatController.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import AVKit

class Chat {
    //  TTS
    func speak(message: String) -> () {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        utterance.rate = 0.4

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
