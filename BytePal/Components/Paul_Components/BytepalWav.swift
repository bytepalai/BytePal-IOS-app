//
//  BytepalWav.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct BytepalWav: View {
    var body: some View {
        Button(action: {
          
            DispatchQueue.global(qos: .userInitiated).async {   // executing functions in here sends user message first
                MakeRequest.sendMessage(message: "hi", userID:"$2b$12$6r5AA4ajhiPSXJBbRVjk3eaeddkG20bNpENxaACMVljiE8yX3UqKu"){
                                            response1, response2 in
                                            print("API Result")
                                            print(response1)
                                               Sounds.playSounds(soundfile: response2)
                                           }
                                       }
             
            
        }) {Text("Messaging")
            }
    }}

struct BytepalWav_Previews: PreviewProvider {
    static var previews: some View {
        BytepalWav()
    }
}
