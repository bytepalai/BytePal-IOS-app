//
//  Debug.swift
//  BytePal
//
//  Created by Scott Hom on 11/28/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

class DebugBP {
    
    // Return path to file, current lien fo print statement, and function currently in
    static func debug(file: String = #file, line: Int = #line, function: String = #function) -> String {
        return "\(file):\(line) : \(function)"
    }
    
}
