//
//  NetworkingController.swift
//  BytePal
//
//  Created by may on 8/4/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import Foundation
import Network
import SwiftUI

//extension NetStatus {
//    static func startNetworkMonitoring() {
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//    }
//
//    static func getNetworkConnectionStatus() -> Bool {
//        return self.monitor.currentPath.status == .satisfied
//    }
//
//    static func getCellularConnectionStatus() -> Bool {
//        return self.monitor.currentPath.isExpensive
//    }
//
//    static func createJSON(data: [String: String]) -> String {
//        let jsonData = try! JSONSerialization.data(withJSONObject: data)
//        let jsonNSString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//        let jsonString = jsonNSString! as String
//        return jsonString
//    }
//}

import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkStatus {
    
    static func getNetworkStatus() {
        let monitor = NWPathMonitor()
    }
    
    static func checkNetworkStatus(completion: @escaping ([String : Bool]) -> Void) {
        let monitor = NWPathMonitor()
        var connectionStatus = [String: Bool]()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                connectionStatus["status"] = true
            } else {
                connectionStatus["status"] = false
            }

            connectionStatus["cellular"] = path.isExpensive ? true : false
            completion(connectionStatus)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

}

