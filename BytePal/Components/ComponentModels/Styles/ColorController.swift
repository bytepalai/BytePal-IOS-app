//
//  ColorController.swift
//  BytePal
//
//  Created by Scott Hom on 8/7/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI

func convertHextoRGB(hexColor: String) -> Color {
    let color: Int = Int(hexColor, radix: 16)!
    let mask = 0x0000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask

    let red = Double(r) / 255.0
    let green = Double(g) / 255.0
    let blue = Double(b) / 255.0
    
    return Color(red: red, green: green, blue: blue)
}
