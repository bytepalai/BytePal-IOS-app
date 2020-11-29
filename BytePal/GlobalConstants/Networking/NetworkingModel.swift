//
//  Constants.swift
//  SwiftUIChatMessage
//
//  Created by Scott Hom on 6/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import Network

// URL Constants
var API_HOSTNAME: String = "https://api.bytepal.io"
var WEBPAGE_HOSTNAME: String = "https://www.bytepal.io"
let navigationBarHeight: Int = 168

struct IDResponse: Codable {
    var user_id: String
}
