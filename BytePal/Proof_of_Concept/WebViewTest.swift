//
//  WebView.swift
//  BytePal
//
//  Created by Scott Hom on 7/17/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI
import WebKit

struct Page : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

struct WebViewTest: View {
    var body: some View {
        Page(request: URLRequest(url: URL(string: "https://bytepal.io/")!))
    }
}

struct WebViewTest_Previews: PreviewProvider {
    static var previews: some View {
        WebViewTest()
    }
}
