//
//  Constants.swift
//  SwiftUIChatMessage
//
//  Created by may on 6/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

var API_HOSTNAME: String = "https://api.bytepal.io"
var Webpage_HOSTNAME: String = "https://www.bytepal.io"
//var API_HOSTNAME: String = "http://34.73.221.176:8001/"
var TEST_SERVER_API_HOSTNAME: String = "http://192.168.86.24:8080/"
let navigationBarHeight: Int = 168

struct IDResponse: Codable {
    var user_id: String
}

struct InteractResponse: Codable {
    var user_id: String
    var text: String
    var type: String
}

// NSURLError

let cannotConnectToServer: Int = -1004
