//
//  File.swift
//  BytePal
//
//  Created by Scott Hom on 8/24/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation

// Add commas to number
class NumberController {
    func commaSeperatedNumber(num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: num)) ?? ""
    }
}
