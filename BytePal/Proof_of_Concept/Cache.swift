//
//  Cache.swift
//  BytePal
//
//  Created by Scott Hom on 7/2/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

// Store data in RAM. Data is lost when app is exited. This is for data that is being for  high performance behaviors over a start and exit app period.

struct Cache: View {
    @State var message: String = ""
    var cache: TextCache = TextCache()
    var body: some View {
        VStack {
            Text("message value: \(message)")
                .padding(16)
            Text("Set Cache")
            TextField("String to be cached", text: $message)
            Button(action: {
                let messageNSString: NSString = self.message as NSString
                self.cache.set(forKey: "test", text: messageNSString)
                self.message = ""
            }){
                Text("Set")
            }
            
            Text("Get Cache")
            Button(action: {
                self.message =  self.cache.get(forKey: "test")! as String
            }){
                Text("Get")
            }   
        }
        
    }
}

struct Cache_Previews: PreviewProvider {
    static var previews: some View {
        Cache()
    }
}

class TextCache {
    var cache = NSCache<NSString, NSString>()
    
    func get(forKey: String) -> NSString? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, text: NSString) {
        cache.setObject(text, forKey: NSString(string: forKey))
    }
}

extension TextCache {
    private static var textCache = TextCache()
    static func getImageCache() -> TextCache {
        return textCache
    }
}
