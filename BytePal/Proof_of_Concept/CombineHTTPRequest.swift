//
//  CombineHTTPRequest.swift
//  BytePal
//
//  Created by may on 7/8/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

struct responseStruct: Decodable {
    var type: String
    var id: String
    var text: String
}

struct CombineHTTPRequest: View {
    @State var message: String = ""
    
    func POSTRequest(text: String) {
        print(text)
//        let endpointInteract = URL(string: "https://webhook.site/c38c1a77-c1a0-4614-ba90-0dbdfc675279")
//        let task = URLSession.shared.dataTask(for: endpointInteract) {
//            .decode(type: responseStruct, decoder: JSONDecoder())
//        }
    }
    var body: some View {
        VStack (alignment: .center) {
            Text("Send Message")
                .font(.custom("Helvetica Bold", size: 20))
                .underline()
            TextField("Enter message here", text: $message)
                .padding(32)
            Button(action: {
                self.POSTRequest(text: self.message)
            }){
                Text("Send")
            }
        }
    }
}

struct CombineHTTPRequest_Previews: PreviewProvider {
    static var previews: some View {
        CombineHTTPRequest()
    }
}
