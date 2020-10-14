//
//  Avatar.swift
//  BytePal
//
//  Created by may on 6/30/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import Speech

struct voiceSlider: View {
    var type: String
    @State public var value: Double = 0.1

    var body: some View {
        VStack {
            Text("\(type)").font(.custom(fontStyle, size: 20))
            Slider(value: $value, in: 0...1, step: 0.1)
            Text("The \(type) is \(value)")
        }
    }
}

struct voicePicker: View {
    var voiceName = ["Arthur", "Daniel", "Martha", "Aaron", "Fred", "Nicky", "Samantha", "Tessa", "Alex"]
    var voiceMap = [
        "Arthur" : "com.apple.ttsbundle.siri_male_en-GB_compact",
        "Daniel" : "com.apple.ttsbundle.Daniel-compact",
        "Martha" : "com.apple.ttsbundle.siri_female_en-GB_compact",
        "Aaron" : "com.apple.ttsbundle.siri_male_en-US_compact",
        "Fred" : "com.apple.speech.synthesis.voice.Fred",
        "Nicky" : "com.apple.ttsbundle.siri_female_en-US_compact",
        "Samantha" : "com.apple.ttsbundle.Samantha-compact",
        "Tessa" : "com.apple.ttsbundle.Tessa-compact",
        "Alex" : "com.apple.speech.voice.Alex"
        
    ]
   @State public var selectedVoice = 0

   var body: some View {
      VStack {
         Picker(selection: $selectedVoice, label: Text("Voice").font(.custom(fontStyle, size: 20))) {
            ForEach(0 ..< voiceName.count) {
               Text(self.voiceName[$0])
            }
         }
        Text("The voice is \(voiceName[selectedVoice]) and their ID is \(voiceMap[voiceName[selectedVoice]]!)")
      }
   }
}

struct Avatar: View {
    @State public var volume: Float = 1.0
    @State public var rate: Float = 0.4
    @State public var pitchMuliplier: Float = 1.0
    @State public var selectedVoice = 0
    var voiceName = ["Arthur", "Daniel", "Martha", "Aaron", "Fred", "Nicky", "Samantha", "Tessa", "Alex"]
     var voiceMap = [
         "Arthur" : "com.apple.ttsbundle.siri_male_en-GB_compact",
         "Daniel" : "com.apple.ttsbundle.Daniel-compact",
         "Martha" : "com.apple.ttsbundle.siri_female_en-GB_compact",
         "Aaron" : "com.apple.ttsbundle.siri_male_en-US_compact",
         "Fred" : "com.apple.speech.synthesis.voice.Fred",
         "Nicky" : "com.apple.ttsbundle.siri_female_en-US_compact",
         "Samantha" : "com.apple.ttsbundle.Samantha-compact",
         "Tessa" : "com.apple.ttsbundle.Tessa-compact",
         "Alex" : "com.apple.speech.voice.Alex"
         
     ]
    
    func speak() -> () {
        let utterance = AVSpeechUtterance(string: "Good afternoon, how are you.")
//        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "\(self.voiceMap[self.voiceName[self.selectedVoice]]!)")
        utterance.volume = self.volume
        utterance.rate = self.rate
        utterance.pitchMultiplier = self.pitchMuliplier
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    var body: some View {
        
        GeometryReader{ geometry in
            VStack {
                ZStack{
                    Circle()
                    .size(CGSize(width: 132, height: 132))
                    .foregroundColor(Color(UIColor.white))
                    .shadow(radius: 7)
                    .padding(EdgeInsets(top: 0, leading: (375/2)-(132/2), bottom: 0, trailing: 0))
                    Image("chatbot")
                        .resizable()
                        .frame(width: 128, height: 128)
                    
                }
                .frame(width: 400, height: 128)
                Picker(selection: self.$selectedVoice, label: Text("Voice: \(self.voiceName[self.selectedVoice])").font(.custom(fontStyle, size: 20))) {
                    ForEach(0 ..< self.voiceName.count) {
                        Text(self.self.voiceName[$0])
                   }
                }
                Text("Volume: \(self.volume)").font(.custom(fontStyle, size: 20))
                Slider(value: self.$volume, in: 0...10, step: 0.1)
                Text("Rate: \(self.rate)").font(.custom(fontStyle, size: 20))
                Slider(value: self.$rate, in: 0...1, step: 0.1)
                Text("Pitch: \(self.pitchMuliplier)").font(.custom(fontStyle, size: 20))
                Slider(value: self.$pitchMuliplier, in: 0...2, step: 0.1)
                Button(action: {
                    self.speak()
                }){
                    Image(systemName: "mic")
                        .font(.system(size: 34))
                        .foregroundColor(convertHextoRGB(hexColor: "ffffff"))
                        .background(
                            Circle()
                                .fill(convertHextoRGB(hexColor: "186ad2"))
                                .frame(width: 64, height: 64)
                        )
                        .padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: (375/2)+128))
                    .shadow(radius: 2)
                        
                }
                    .padding(EdgeInsets(top: 0, leading: 375 - 48, bottom: 0, trailing: 0))
                Spacer()
            }
        }
    }
}

struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar()
    }
}
