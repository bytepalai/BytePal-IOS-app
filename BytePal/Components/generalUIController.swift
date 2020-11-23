//
//  generalUIController.swift
//  BytePal
//
//  Created by Scott Hom on 10/26/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import SwiftUI

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
