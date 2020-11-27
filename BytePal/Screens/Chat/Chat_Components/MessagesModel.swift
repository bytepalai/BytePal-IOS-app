//
//  MessageModel.swift
//  BytePal
//
//  Created by Scott Hom on 10/14/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI

class Messages: ObservableObject {
    @Published var list: [[String: Any]] = [[String: Any]]()
    @Published var messagesLeft: Int = -1
}
