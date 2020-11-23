//
//  Size.swift
//  BytePal
//
//  Created by Scott Hom on 10/30/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import SwiftUI

struct ViewRelativeSize {
    var height: CGFloat = UIScreen.main.bounds.size.height
    var width: CGFloat = UIScreen.main.bounds.size.width
    var heightMessageHistoryView: CGFloat = CGFloat(0.0)
    var deviceInfo: DeviceInfo = DeviceInfo()
    init() {
        deviceInfo.setDeviceGroup()
        
        switch deviceInfo.deviceSizeGroup {
            case "iPhone12ProMaxDeviceGroup":
                self.setViewConstantsiPhone12ProMaxGroup()
            case "iPhone11ProMaxDeviceGroup":
                self.setViewConstantsiPhone11ProMaxDeviceGroup()
            case "iPhone12DeviceGroup":
                self.setViewConstantsiPhone12DeviceGroup()
            case "iPhone11ProDeviceGroup":
                self.setViewConstantsiPhone11ProDeviceGroup()
            case "iPhone6SPlusDeviceGroup":
                self.setViewConstantsiPhone6SPlusDeviceGroup()
            case "iPhone6SDeviceGroup":
                self.setViewConstantsiPhone6SDeviceGroup()
            default:
                print("Error: BytePal does not support the device group \(deviceInfo.deviceSizeGroup)")
        }
    }
}

extension ViewRelativeSize {
    mutating func setViewConstantsiPhone12ProMaxGroup(){
        self.heightMessageHistoryView =  CGFloat(self.height*0.65)
    }
    
    mutating func setViewConstantsiPhone11ProMaxDeviceGroup() {
        self.heightMessageHistoryView =  CGFloat(self.height)
    }
    
    mutating func setViewConstantsiPhone12DeviceGroup() {
        self.heightMessageHistoryView =  CGFloat(self.height*0.725)
    }
    
    mutating func setViewConstantsiPhone11ProDeviceGroup() {
        self.heightMessageHistoryView =  CGFloat(self.height*0.725)
    }
    
    mutating func setViewConstantsiPhone6SPlusDeviceGroup() {
        self.heightMessageHistoryView =  CGFloat(self.height*0.825)
    }
    
    mutating func setViewConstantsiPhone6SDeviceGroup() {
        self.heightMessageHistoryView =  CGFloat(self.height*0.825)
    }
}

//struct iPhone12ProMax {
//    let heightScalingFactorMessageHistoryView: Float = 0.650
//}
//
//struct iPhone11ProMax {
//    let heightScalingFactorMessageHistoryView: Float = 0.650
//}
//
//struct iPhone12 {
//    let heightScalingFactorMessageHistoryView: Float = 0.725
//}
//
//struct iPhone11Pro {
//    let heightScalingFactorMessageHistoryView: Float = 0.725
//}
//
//struct iPhone6SPlus {
//    let heightScalingFactorMessageHistoryView: Float = 0.825
//}
//
//struct iPhon6S {
//    let heightScalingFactorMessageHistoryView: Float = 0.825
//}

struct ViewRelativeSize_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
