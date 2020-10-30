//
//  DetectDominantLanguage.swift
//  BytePal
//
//  Created by Scott Hom on 7/17/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct DetectDominantLanguage: View {
    @State var textFieldString: String = ""
    @State var language: String = ""
    
    var languageMap = [
        "en" : "English",
        "fr" : "French",
        "zh-Hans" : "Chinese"
    ]
    
    func detect(text: String) -> String {

        if let language = NSLinguisticTagger.dominantLanguage(for: text) {
            return language
        } else {
            return "Unknown language"
        }
    }
    
    var body: some View {
        VStack{
            Text("Language Detection")
                .font(.custom(fontStyle, size: 24))
                .padding(32)
            TextField("Enter text here", text: $textFieldString)
                .frame(width: 300)
                .padding(8)
            Button(action: {
                self.language = self.detect(text: self.textFieldString)
            }){
                Text("Detect")
            }
            Text("Langauge: \(self.languageMap[self.language] ?? "")")
                .font(.custom(fontStyle, size: 16))
                .padding(16)
            
        }
    }
}

struct DetectDominantLanguage_Previews: PreviewProvider {
    static var previews: some View {
        DetectDominantLanguage()
    }
}
